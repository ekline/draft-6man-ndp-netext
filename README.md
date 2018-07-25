# draft-6man-ndp-netext
IPv6 Neighbor Discovery Protocol for Network Extensions
```




Network Working Group                                           E. Kline
Internet-Draft                                              Google Japan
Intended status: Standards Track                           July 25, 2018
Expires: January 26, 2019


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

   This Internet-Draft will expire on January 26, 2019.

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




Kline                   Expires January 26, 2019                [Page 1]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   the Trust Legal Provisions and are provided without warranty as
   described in the Simplified BSD License.

Table of Contents

   1.  Introduction  . . . . . . . . . . . . . . . . . . . . . . . .   2
     1.1.  Terminology . . . . . . . . . . . . . . . . . . . . . . .   2
     1.2.  Requirements Notation . . . . . . . . . . . . . . . . . .   3
     1.3.  Why Network Extension protocol  . . . . . . . . . . . . .   3
   2.  Network Extension Overview  . . . . . . . . . . . . . . . . .   3
   3.  Network Extension Message . . . . . . . . . . . . . . . . . .   4
     3.1.  Network Extension Solicitation  . . . . . . . . . . . . .   5
       3.1.1.  Requesting Node behavior  . . . . . . . . . . . . . .   6
       3.1.2.  Allocating Router behavior  . . . . . . . . . . . . .   6
     3.2.  Network Extension Allocation  . . . . . . . . . . . . . .   6
       3.2.1.  Allocating Router behavior  . . . . . . . . . . . . .   7
       3.2.2.  Requesting Node behavior  . . . . . . . . . . . . . .   7
     3.3.  Network Extension Report  . . . . . . . . . . . . . . . .   8
       3.3.1.  Allocating Router behavior  . . . . . . . . . . . . .   8
       3.3.2.  Requesting Node behavior  . . . . . . . . . . . . . .   8
   4.  Security Considerations . . . . . . . . . . . . . . . . . . .   8
   5.  IANA Considerations . . . . . . . . . . . . . . . . . . . . .   8
   6.  References  . . . . . . . . . . . . . . . . . . . . . . . . .   9
     6.1.  Normative References  . . . . . . . . . . . . . . . . . .   9
     6.2.  Informative References  . . . . . . . . . . . . . . . . .  10
   Author's Address  . . . . . . . . . . . . . . . . . . . . . . . .  10

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



Kline                   Expires January 26, 2019                [Page 2]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   temporarily exhausted resources for allocation, e.g. has already
   delegated all possible prefixes to requesters, is still considered an
   allocating router, albeit an exhausted one.)

1.2.  Requirements Notation

   The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
   "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
   document are to be interpreted as described in [RFC2119].

1.3.  Why Network Extension protocol

   Limitations of current approaches:

   o  No provision for routers to learn previously delegated prefixes.

   o  No provision for multiple prefixes delegated from multiple
      routers.

   o  No support for provisioning domains [RFC7556].

   The Network Extension protocol is designed to:

   o  Offer Requesting Nodes a means to request an extension of the
      network from multiple routers and/or from multiple Provisioning
      Domains ([RFC7556]).

   o  Compatibility with existing deployments/implementations: Support
      models where one or more on-link prefixes may be shared by
      multiple hosts while Requesting Nodes may be allocated network
      extension resources.  Nodes that do not implement the network
      extension are unaffected in a mixed deployment.

   o  Preserve the security model of RA Guard ([RFC6105]).

2.  Network Extension Overview

   The Network Extension protocol is designed to preserve the security
   model of RA Guard ([RFC6105]), while offering Requesting Nodes the
   means to request an extension of the network from multiple routers
   and/or from multiple Provisioning Domains ([RFC7556]).  It also
   supports models where one or more on-link prefixes may be shared by
   multiple hosts while Requesting Nodes may be allocated network
   extension resources.

   In order to do this, Requesting Nodes only communicate via unicast
   Network Extension messages with routers to which they have configured
   one or more routes (either statically or dynamically, e.g. a default



Kline                   Expires January 26, 2019                [Page 3]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   route or one or more RIOs).  This increases the number of message
   exchanges to up to four (RS, RA, NES, NEA), but ensures that only
   routers permitted to send RAs (as ensured by, for example, RA Guard
   [RFC6105]) can cause requesting routers to configure network
   extension parameters.  It also ensures that Allocating Routers can
   continue to multicast RAs suitable for all listening nodes.

   A Requesting Node MAY send a unicast Network Extension Solicitation
   (NES) to the link-local address of any router to which is has routes
   with non-zero preferred lifetimes.  Typically, this request can be
   sent after a node has received, processed, and accepted a suitable
   RA.

   The NES MUST contain either one or more PIOs indicating the desired
   prefix(es) or length requested, or a PVD container option containing
   the same.

   An Allocating Router MAY send a unicast Network Extension Allocation
   message to any node on-link.  Typically this will be in response to
   an NES, though an allocation may be made to a node (and the node
   informed via NEA) unilaterally by the Allocating Router.  As an
   example of the latter case, a router may respond to an RS with an RA
   (most likely unicast) followed immediately by a unicast NEA.  [Why
   support unsolicited NEA?]

3.  Network Extension Message

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |     Type      |     Code      |          Checksum             |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                           Reserved                            |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |   Options ...
   +-+-+-+-+-+-+-+-+-+-+-+-

            Figure 1: IPv6 NDP Network Extension Message format

   IP Fields:

   Source Address  The link-local address of the sender.

   Destination Address  Either the link-local address of the destination
      or the link-local multicast
      All_Network_Extension_Requesting_Routers address (see [citation]),
      depending upon the Code and mode of operation.




Kline                   Expires January 26, 2019                [Page 4]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   Hop Limit  255

   ICMP Fields:

   Type        (8 bits) ICMPV6_TYPE_NE_TBD (IANA)

   Code        (8 bits) The type of request Code:

      Network Extension Solicitation (0)  The Network Extension
         Solicitation (NES) is sent by the Requesting Node to potential
         Allocating Router.  It is sent to the link-local address from
         which an RA was received (processed and accepted).

      Network Extension Allocation (1)  The Network Extension Allocation
         (NEA) is sent in response to NES by an Allocating Router to
         Requesting Node or by an Allocating Router to any node on the
         link.

      Network Extension Report (2)  The Network Extension Report (NER)
         is sent by Allocating Router to Request Node or to
         All_Network_Extension_Requesting_Routers.

   Checksum    (16 bits) The ICMP checksum; see [RFC4443]

   Reserved    32 bit unused field.  It MUST be initialized to zero by
      the sender and MUST be ignored by the receiver.

   Possible options

      Prefix Information Option (PIO):  May be included in NES, NEA (and
         NER?).  Multiple PIOs can be included in the same message.
         There may be zero or more RA options included along with PIO
         that are valid as part of the Router Advertisement to convey
         additional configuration such as RIO, DNS Server list..? in the
         NEA message.

      PvD ID Option:  May be included in NES, NEA (and NER?).

      Route Information Option(RIO):  May be included in NEA.

      Nonce option:  May be included in NES, NER, NEA.

3.1.  Network Extension Solicitation

   The Network Extension Solicitation(NES) message is unicast message
   sent by Requesting Nodes to Allocating Router from which an RA was
   received, processed and accepted.  The Requesting Node initiates NES
   message to request for a dedicated prefix or to re-confirm validity



Kline                   Expires January 26, 2019                [Page 5]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   of the prefixes allocated to it.  NES may be triggered in response to
   NER message from the Allocating Router.

   IP fields

      Source Address  The link-local address of the Requesting Node.

      Destination Address  The link-local address of the Allocating
         Router learnt from RA received, processed and accepted.

   ICMP Fields

      Type   ICMPV6_TYPE_NE_TBD (IANA)

      Code    Network Extension Solicitation (0)

   Options

      PIO Option(s):  PIO options as received in the RA or PIO option
         with the length of the desired dedicated prefix or PIO options
         allocated to the Requesting Node (with valid lifetime set to
         remaining lifetime?).

      PVD ID Option:  PVD ID container option as defined in
         [I-D.ietf-intarea-provisioning-domains] received in the RA with
         the PIO options contained within or previously allocated to the
         Requesting Node.

      Nonce Option:  Nonce option as defined in [RFC3971] with the nonce
         value containing a random number generated by the Requesting
         Node.  If the NES is triggered in response to NER then the
         nonce value is populated with the value of the Nonce Option
         received in NER.

3.1.1.  Requesting Node behavior

3.1.2.  Allocating Router behavior

3.2.  Network Extension Allocation

   The Network Extension Allocation (NEA) message is an unicast message
   sent in response to NES by an Allocating Router to Requesting Node or
   by an Allocating Router to any node on the link.  The NEA message
   contains options to provide prefix data or hint about the
   unavailability of the requested prefix.

   IP fields




Kline                   Expires January 26, 2019                [Page 6]

Internet-Draft         IPv6 NDP Network Extension              July 2018


      Source Address  The link-local address of the Allocating Router.

      Destination Address  The link-local address of the Requesting Node
         received in the source of NES message or source in RS.

   ICMP Fields

      Type   ICMPV6_TYPE_NE_TBD (IANA)

      Code    Network Extension Allocation (1)

   Options

      PIO Option(s):  PIO options containing the dedicated prefix
         allocated to the Requesting Node.  If no dedicated prefix is
         available then a PIO with ::/0 prefix is returned.  If the PIO
         with ::/0 prefix contains non-zero lifetime then that SHOULD be
         used as a hint by the Requesting Node for the shortest interval
         to retry NES again.  If the PIO with ::/0 prefix contains zero
         lifetime then the Requesting Node SHOULD NOT send any more NES
         to the Allocating Router until it receives NER from the
         Allocating Router.

      PVD ID Option:  PVD ID container option as defined in
         [I-D.ietf-intarea-provisioning-domains] containing PIO with
         dedicated prefix.  If no dedicated prefix is available in the
         PVD ID requested then a PIO with ::/0 prefix is returned.  If
         the PIO with ::/0 prefix contains non-zero lifetime then that
         should be used as a hint by the Requesting Node for the
         shortest interval to retry NES again.  If the PIO with ::/0
         prefix contains zero lifetime then the Requesting Node SHOULD
         NOT send any more NES to the Allocating Router until it
         receives NER from the Allocating Router.

      Nonce Option:  Nonce option as defined in [RFC3971] with the nonce
         value containing a random number received in the corresponding
         NES message.

      Route Information Option(RIO):

3.2.1.  Allocating Router behavior

3.2.2.  Requesting Node behavior








Kline                   Expires January 26, 2019                [Page 7]

Internet-Draft         IPv6 NDP Network Extension              July 2018


3.3.  Network Extension Report

   The Network Extension Report (NER) message is sent by an Allocating
   Router to a specific node on the link or to
   All_Network_Extension_Requesting_Routers address to trigger possible
   NES exchange.  This can be sent (by Allocating Router to reconstruct
   its state on reboot for previously allocated prefixes? and ) when an
   Allocating Router has dedicated prefixes to offer.

   IP fields

      Source Address  The link-local address of the Allocating Router.

      Destination Address  The link-local address of the Requesting Node
         received in the source of a NES message or
         All_Network_Extension_Requesting_Routers address.

   ICMP Fields

      Type   ICMPV6_TYPE_NE_TBD (IANA)

      Code    Network Extension Report (2)

3.3.1.  Allocating Router behavior

3.3.2.  Requesting Node behavior

4.  Security Considerations

   - Rogue Allocating Routers can issue bogus prefixes to requestors.
   This may cause denial of service due to unreachability.  Security
   model offered by RA guard should mitigate this.

   - Rogue Requesting Nodes may consume resources from legitimate
   Allocating Routers, thus denying others the use of the prefixes.  The
   use of SEND ([RFC3971]) is recommended to protect the integrity of
   the messages and authenticate the identity of the Requesting Nodes.

   It is recommended to configure control plane policing on Allocating
   Routers to rate limit processing of NES messages.

5.  IANA Considerations

   Request IANA to allocate a link-local multicast address, ff02::XXX,
   All_Network_Extension_Requesting_Routers.






Kline                   Expires January 26, 2019                [Page 8]

Internet-Draft         IPv6 NDP Network Extension              July 2018


   This document requests for a new ICMPv6 type ICMPV6_TYPE_NE_TBD to be
   allocated from "ICMP Type Numbers" registry in the informational
   message range.

   The following codes are requested from the ICMPV6_TYPE_NE_TBD
   subregistry:

   0  Network Extension Solicitation

   1  Network Extension Allocation

   2  Network Extension Report

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

   [RFC3971]  Arkko, J., Ed., Kempf, J., Zill, B., and P. Nikander,
              "SEcure Neighbor Discovery (SEND)", RFC 3971,
              DOI 10.17487/RFC3971, March 2005, <https://www.rfc-
              editor.org/info/rfc3971>.

   [RFC4443]  Conta, A., Deering, S., and M. Gupta, Ed., "Internet
              Control Message Protocol (ICMPv6) for the Internet
              Protocol Version 6 (IPv6) Specification", STD 89,
              RFC 4443, DOI 10.17487/RFC4443, March 2006,
              <https://www.rfc-editor.org/info/rfc4443>.

   [RFC4861]  Narten, T., Nordmark, E., Simpson, W., and H. Soliman,
              "Neighbor Discovery for IP version 6 (IPv6)", RFC 4861,
              DOI 10.17487/RFC4861, September 2007, <https://www.rfc-
              editor.org/info/rfc4861>.








Kline                   Expires January 26, 2019                [Page 9]

Internet-Draft         IPv6 NDP Network Extension              July 2018


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

































Kline                   Expires January 26, 2019               [Page 10]
```
