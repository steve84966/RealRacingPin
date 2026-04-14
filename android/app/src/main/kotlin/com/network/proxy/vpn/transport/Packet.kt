package com.network.realracingpin.vpn.transport

import com.network.realracingpin.vpn.transport.protocol.IP4Header
import com.network.realracingpin.vpn.transport.protocol.TransportHeader

class Packet(var ipHeader: IP4Header, var transportHeader: TransportHeader, var buffer: ByteArray) {
}