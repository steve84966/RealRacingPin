package com.network.realracingpin.vpn.socket

import com.network.realracingpin.vpn.Connection

interface CloseableConnection {
    /**
     * 关闭连接
     */
    fun closeConnection(connection: Connection)
}