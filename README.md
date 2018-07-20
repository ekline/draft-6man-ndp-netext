# draft-6man-ndp-netext
IPv6 Neighbor Discovery Protocol for Network Extensions
```




Network Working Group                                           E. Kline
Internet-Draft                                              Google Japan
Intended status: Standards Track                           July 20, 2018
Expires: January 21, 2019


         IPv6 Neighbor Discovery Protocol for Network Extension
                    draft-sixxers-6man-ndp-netext-00

Abstract

   This document describes a protocol that uses new options in the IPv6
   Neighbor Discovery Protocol [RFC4861] to extend IPv6 networks.  The
   approach described has several advantages over existing techniques,
   chief among them the ability to work with the Provisioning Domain
   (PvD) architecture [I-D.ietf-intarea-provisioning-domains].

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

   This Internet-Draft will expire on January 21, 2019.

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
   the Trust Legal Provisions and are provided without warranty as
   described in the Simplified BSD License.



Kline                   Expires January 21, 2019                [Page 1]

Internet-Draft         IPv6 NDP Network Extension              July 2018


Table of Contents

   1.  Introduction  . . . . . . . . . . . . . . . . . . . . . . . .   2
     1.1.  Requirements Notation . . . . . . . . . . . . . . . . . .   2
   2.  Network Extension Message . . . . . . . . . . . . . . . . . .   2
   3.  IANA Considerations . . . . . . . . . . . . . . . . . . . . .   3
   4.  Normative References  . . . . . . . . . . . . . . . . . . . .   3
   Author's Address  . . . . . . . . . . . . . . . . . . . . . . . .   3

1.  Introduction

1.1.  Requirements Notation

   The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT",
   "SHOULD", "SHOULD NOT", "RECOMMENDED", "MAY", and "OPTIONAL" in this
   document are to be interpreted as described in [RFC2119].

2.  Network Extension Message

    0                   1                   2                   3
    0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |     Type      |     Code      |          Checksum             |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
   |                           Reserved                            |
   +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+

            Figure 1: IPv6 NDP Network Extension Message format

   IP Fields:

   Source Address  The link-local address of the sender.

   Destination Address

   Hop Limit  255

   ICMP Fields:

   Type        (8 bits) TBD (IANA)

   Code        (8 bits) TBD (IANA)

   Checksum    (16 bits) The ICMP checksum; see [RFC4443]

   Reserved    32 bit unused field.  It MUST be initialized to zero by
      the sender and MUST be ignored by the receiver.




Kline                   Expires January 21, 2019                [Page 2]

Internet-Draft         IPv6 NDP Network Extension              July 2018


3.  IANA Considerations

   Request IANA to allocate a link-local multicast address, ff02::XXX,
   All_Network_Extension_Requesting_Routers.

4.  Normative References

   [I-D.ietf-intarea-provisioning-domains]
              Pfister, P., Vyncke, E., Pauly, T., Schinazi, D., and W.
              Shao, "Discovering Provisioning Domain Names and Data",
              draft-ietf-intarea-provisioning-domains-02 (work in
              progress), June 2018.

   [RFC2119]  Bradner, S., "Key words for use in RFCs to Indicate
              Requirement Levels", BCP 14, RFC 2119,
              DOI 10.17487/RFC2119, March 1997, <https://www.rfc-
              editor.org/info/rfc2119>.

   [RFC4443]  Conta, A., Deering, S., and M. Gupta, Ed., "Internet
              Control Message Protocol (ICMPv6) for the Internet
              Protocol Version 6 (IPv6) Specification", STD 89,
              RFC 4443, DOI 10.17487/RFC4443, March 2006,
              <https://www.rfc-editor.org/info/rfc4443>.

   [RFC4861]  Narten, T., Nordmark, E., Simpson, W., and H. Soliman,
              "Neighbor Discovery for IP version 6 (IPv6)", RFC 4861,
              DOI 10.17487/RFC4861, September 2007, <https://www.rfc-
              editor.org/info/rfc4861>.

Author's Address

   Erik Kline
   Google Japan
   Roppongi 6-10-1, 44th Floor
   Minato, Tokyo  106-6144
   Japan















Kline                   Expires January 21, 2019                [Page 3]
```
