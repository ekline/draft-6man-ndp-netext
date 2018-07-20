# draft-6man-ndp-netext
IPv6 Neighbor Discovery Protocol for Network Extensions
```




Network Working Group                                           E. Kline
Internet-Draft                                              Google Japan
Intended status: Standards Track                           July 21, 2018
Expires: January 22, 2019


         IPv6 Neighbor Discovery Protocol for Network Extension
                    draft-sixxers-6man-ndp-netext-00

Abstract

   This document describes a protocol that uses new options in the IPv6
   Neighbor Discovery Protocol [RFC4861] to extend IPv6 networks.  The
   approach described has several advantages over existing techniques,
   chief among them the ability to work with the Provisioning Domain
   (PvD) architecture ([RFC7556],
   [I-D.ietf-intarea-provisioning-domains]).

Status of This Memo

   This Internet-Draft is submitted in full conformance with the
   provisions of BCP 78 and BCP 79.

   Internet-Drafts are working documents of the Internet Engineering
   Task Force (IETF).  Note that other groups may also distribute
   working documents as Internet-Drafts.  The list of current Internet-
   Drafts is at http://datatracker.ietf.org/drafts/current/.

   Internet-Drafts are draft documents valid for a maximum of six months
   and may be updated, replaced, or obsoleted by other documents at any
   time.  It is inappropriate to use Internet-Drafts as reference
   material or to cite them other than as "work in progress."

   This Internet-Draft will expire on January 22, 2019.

Copyright Notice

   Copyright (c) 2018 IETF Trust and the persons identified as the
   document authors.  All rights reserved.

   This document is subject to BCP 78 and the IETF Trust's Legal
   Provisions Relating to IETF Documents
   (http://trustee.ietf.org/license-info) in effect on the date of
   publication of this document.  Please review these documents
   carefully, as they describe your rights and restrictions with respect
   to this document.  Code Components extracted from this document must
   include Simplified BSD License text as described in Section 4.e of




Kline                   Expires January 22, 2019                [Page 1]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   the Trust Legal Provisions and are provided without warranty as
   described in the Simplified BSD License.

Table of Contents

   1.  Introduction  . . . . . . . . . . . . . . . . . . . . . . . .   2
     1.1.  Terminology . . . . . . . . . . . . . . . . . . . . . . .   2
     1.2.  Requirements Notation . . . . . . . . . . . . . . . . . .   2
   2.  Network Extension Overview  . . . . . . . . . . . . . . . . .   3
   3.  Network Extension Message . . . . . . . . . . . . . . . . . .   3
   4.  Network Extension Solicitation  . . . . . . . . . . . . . . .   4
   5.  IANA Considerations . . . . . . . . . . . . . . . . . . . . .   4
   6.  References  . . . . . . . . . . . . . . . . . . . . . . . . .   4
     6.1.  Normative References  . . . . . . . . . . . . . . . . . .   4
     6.2.  Informative References  . . . . . . . . . . . . . . . . .   5
   Author's Address  . . . . . . . . . . . . . . . . . . . . . . . .   5

1.  Introduction

   This document describes a protocol that uses new options in the IPv6
   Neighbor Discovery Protocol [RFC4861] to extend IPv6 networks.  The
   approach described has several advantages over existing techniques,
   chief among them the ability to work with the Provisioning Domain
   (PvD) architecture ([RFC7556],
   [I-D.ietf-intarea-provisioning-domains]).

1.1.  Terminology

   Requesting Node: a node (a router, a host, a node running within
   another node i.e. in a VM) attempting to extend the IPv6 network.
   These nodes listen for, process, and can accept RAs (i.e. program
   routes as learned from the RA).

   Allocating Router: a node (a router, or a node running other nodes
   within itself i.e. in a VM) configured to allocate resources required
   for network extension to a requesting node and able to act as a
   router for some destinations not contained within any of the
   allocated prefixes.  (Note that an allocating router that has
   temporarily exhausted resources for allocation, e.g. has already
   delegated all possible prefixes to requesters, is still considered an
   allocating router, albeit an exhausted one.)

1.2.  Requirements Notation

   The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
   "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
   document are to be interpreted as described in [RFC2119].




Kline                   Expires January 22, 2019                [Page 2]

Internet-Draft         IPv6 NDP Network Extension              July 2018


2.  Network Extension Overview

   The Network Extension protocol is designed to preserve the security
   model of RA Guard ([RFC6105]), while offering requesting nodes the
   means to request an extension of the network from multiple routers
   and/or from multiple Provisioning Domains ([RFC7556]).  It also
   supports models where one or more on-link prefixes may be shared by
   multiple hosts while requesting nodes may be allocated network
   extension resources.

   In order to do this, requesting nodes only communicate via unicast
   Network Extension messages with routers to which they have configured
   one or more routes (either statically or dynamically, e.g. a default
   route or one or more RIOs).  This increases the number of message
   exchanges to up to four (RS, RA, NES, NEA), but ensures that only
   routers permitted to send RAs (as ensured by, for example, RA Guard
   [RFC6105]) can cause requesting routers to configure network
   extension parameters.  It also ensures that allocating routers can
   continue to multicast RAs suitable for all listening nodes.

   A requesting node MAY send a unicast Network Extension Solicitation
   (NES) to the link-local address of any router to which is has routes
   with non-zero preferred lifetimes.  Typically, this request can be
   sent after a node has received, processed, and accepted a suitable
   RA.

   The NES MUST contain either one or more PIOs indicating the desired
   prefix(es) or length requested, or a PVD container option containing
   the same.

   An allocating router MAY send a unicast Network Extension Allocation
   message to any node on-link.  Typically this will be in response to
   an NES, though an allocation may be made to a node (and the node
   informed via NEA) unilaterally by the allocating router.  As an
   example of the latter case, a router may respond to an RS with an RA
   (most likely unicast) followed immediately by a unicast NEA.

3.  Network Extension Message

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |     Type      |     Code      |          Checksum             |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                           Reserved                            |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

            Figure 1: IPv6 NDP Network Extension Message format



Kline                   Expires January 22, 2019                [Page 3]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   IP Fields:

   Source Address  The link-local address of the sender.

   Destination Address  Either the link-local address of the destination
      or the link-local multicast
      All_Network_Extension_Requesting_Routers address (see [citation]),
      depending upon the Code and mode of operation.

   Hop Limit  255

   ICMP Fields:

   Type        (8 bits) TBD (IANA)

   Code        (8 bits) TBD (IANA)

   Checksum    (16 bits) The ICMP checksum; see [RFC4443]

   Reserved    32 bit unused field.  It MUST be initialized to zero by
      the sender and MUST be ignored by the receiver.

4.  Network Extension Solicitation

   Code: 0 Rules for Requesting Nodes - source address must be a link-
   local address of the interface - destination address must be the
   link-local address from which an RA was received (processed and
   accepted).

5.  IANA Considerations

   Request IANA to allocate a link-local multicast address, ff02::XXX,
   All_Network_Extension_Requesting_Routers.

6.  References

6.1.  Normative References

   [I-D.ietf-intarea-provisioning-domains]
              Pfister, P., Vyncke, E., Pauly, T., Schinazi, D., and W.
              Shao, "Discovering Provisioning Domain Names and Data",
              draft-ietf-intarea-provisioning-domains-02 (work in
              progress), June 2018.

   [RFC2119]  Bradner, S., "Key words for use in RFCs to Indicate
              Requirement Levels", BCP 14, RFC 2119,
              DOI 10.17487/RFC2119, March 1997, <https://www.rfc-
              editor.org/info/rfc2119>.



Kline                   Expires January 22, 2019                [Page 4]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   [RFC4443]  Conta, A., Deering, S., and M. Gupta, Ed., "Internet
              Control Message Protocol (ICMPv6) for the Internet
              Protocol Version 6 (IPv6) Specification", STD 89,
              RFC 4443, DOI 10.17487/RFC4443, March 2006,
              <https://www.rfc-editor.org/info/rfc4443>.

   [RFC4861]  Narten, T., Nordmark, E., Simpson, W., and H. Soliman,
              "Neighbor Discovery for IP version 6 (IPv6)", RFC 4861,
              DOI 10.17487/RFC4861, September 2007, <https://www.rfc-
              editor.org/info/rfc4861>.

6.2.  Informative References

   [RFC6105]  Levy-Abegnoli, E., Van de Velde, G., Popoviciu, C., and J.
              Mohacsi, "IPv6 Router Advertisement Guard", RFC 6105,
              DOI 10.17487/RFC6105, February 2011, <https://www.rfc-
              editor.org/info/rfc6105>.

   [RFC7556]  Anipko, D., Ed., "Multiple Provisioning Domain
              Architecture", RFC 7556, DOI 10.17487/RFC7556, June 2015,
              <https://www.rfc-editor.org/info/rfc7556>.

Author's Address

   Erik Kline
   Google Japan
   Roppongi 6-10-1, 44th Floor
   Minato, Tokyo  106-6144
   Japan






















Kline                   Expires January 22, 2019                [Page 5]
```
