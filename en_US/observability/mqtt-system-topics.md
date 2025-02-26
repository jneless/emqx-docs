# System Topic

EMQX periodically publishes its running status, message statistics, client online and offline events to the system topic starting with `$SYS/`.

The `$SYS` topic path begins with `$SYS/brokers/{node}/`, where `{node}` is the name of the node where the event/message is generated, for example:

```bash
$SYS/brokers/emqx@127.0.0.1/version
$SYS/brokers/emqx@127.0.0.1/uptime
```

The `$SYS` system message publish interval is configured via Dashboard‘s `Management/MQTT Setting/System Topic`.

::: tip
By default, only MQTT clients on localhost are allowed to subscribe to the `$SYS` topic.
Please refer to [File Authorization](../access-control/authz/file.md) to modify the ACL rules for publish and subscribe.


Most of the data of the `$SYS` topic in EMQX can be obtained through other methods with lower Couplings.
The device online and offline status can be captured and processed in the Rule Engine.
:::

## Cluster Status Information

| Topic                          | Description       |
| ------------------------------ | ----------------- |
| $SYS/brokers                   | cluster node list |
| $SYS/brokers/\${node}/version  | EMQX  version     |
| $SYS/brokers/\${node}/uptime   | EMQX startup time |
| $SYS/brokers/\${node}/datetime | EMQX time         |
| $SYS/brokers/\${node}/sysdescr | EMQX description  |

## Client Online and Offline Events

Those events is enabled by default, please refer to `sys_topics.sys_event_messages` to turn it off.

`$SYS` topic prefix: `$SYS/brokers/${node}/clients/`

| Topic                    | Description                                                       |
| ------------------------ | ----------------------------------------------------------------- |
| ${clientid}/connected    | Online event. This message is published when a client goes online |
| ${clientid}/disconnected | Offline event. This message is published when a client is offline |

 The Payload of the `connected` event message can be parsed into JSON format:

```bash
{
    "username": "foo",
    "ts": 1625572213873,
    "sockport": 1883,
    "proto_ver": 4,
    "proto_name": "MQTT",
    "keepalive": 60,
    "ipaddress": "127.0.0.1",
    "expiry_interval": 0,
    "connected_at": 1625572213873,
    "connack": 0,
    "clientid": "emqtt-8348fe27a87976ad4db3",
    "clean_start": true
}
```

 The Payload of the `disconnected` event message can be parsed into JSON format:

```bash
{
    "username": "foo",
    "ts": 1625572213873,
    "sockport": 1883,
    "reason": "tcp_closed",
    "proto_ver": 4,
    "proto_name": "MQTT",
    "ipaddress": "127.0.0.1",
    "disconnected_at": 1625572213873,
    "clientid": "emqtt-8348fe27a87976ad4db3"
}
```

## Client Subscribed and Unsubscribed Events

Those events is disenabled by default, please refer to `sys_topics.sys_event_messages` to turn it on.

`$SYS` topic prefix: `$SYS/brokers/${node}/clients/`

| Topic                    | Description                              |
| ------------------------ | ---------------------------------------- |
| ${clientid}/subscribed   | Subscribed event. This message is published when a client subscribes a topic |
| ${clientid}/unsubscribed | Unsubscribed event. This message is published when a client unsubscribes a topic |

The Payload of the `subscribed` event message can be parsed into JSON format:

```bash
{
    "username":"foo",
    "ts":1625572213878,
    "topic":"/the/best/mqtt/broker/is/emqx",
    "subopts":{
        "sub_props":{},
        "rh":0,
        "rap":0,
        "qos":0,
        "nl":0,
        "is_new":true
    },
    "protocol":"mqtt",
    "clientid":"emqtt-8348fe27a87976ad4db3"
}

```

 The Payload of the `unsubscribed` event message can be parsed into JSON format:

```bash
{
    "username":"foo",
    "ts":1625572213899,
    "topic":"/the/best/mqtt/broker/is/emqx",
    "protocol":"mqtt",
    "clientid":"emqtt-8348fe27a87976ad4db3"
}
```


## Statistics

System topic prefix : `$SYS/brokers/${node}/stats/`

### Client Statistics

| Topic             | Description                     |
| ----------------- | ------------------------------- |
| connections/count | Total number of current clients |
| connections/max   | Maximum number of clients       |

### Subscription Statistics

| Topic                      | Description                                  |
| -------------------------- | -------------------------------------------- |
| suboptions/count           | number of current subscription options       |
| suboptions/max             | total number of maximum subscription options |
| subscribers/count          | number of current subscribers                |
| subscribers/max            | maximum number of subscriptions              |
| subscriptions/count        | total number of current subscription         |
| subscriptions/max          | maximum number of subscriptions              |
| subscriptions/shared/count | total number of current shared subscriptions |
| subscriptions/shared/max   | maximum number of shared subscriptions       |

### Topic Statistics

| Topic        | Description                    |
| ------------ | ------------------------------ |
| topics/count | total number of current topics |
| topics/max   | maximum number of topics       |

### Routes Statistics

| Topic        | Description                    |
| ------------ | ------------------------------ |
| routes/count | total number of current Routes |
| routes/max   | maximum number of Routes       |

 The topics/count and topics/max are numerically equal to routes/count and routes/max.

### Throughput (Bytes/Packets/Message) Statistics

 System Topic Prefix : `$SYS/brokers/${node}/metrics/`

### Sent and Received Bytes Statistics

| Topic          | Description                |
| -------------- | -------------------------- |
| bytes/received | Accumulated received bytes |
| bytes/sent     | Accumulated sent bytes     |

### Sent and Received MQTT Packets Statistics

| Topic                        | Description                                      |
| ---------------------------- | ------------------------------------------------ |
| packets/received             | Accumulative received MQTT packets               |
| packets/sent                 | Accumulative sent MQTT packets                   |
| packets/connect/received     | Accumulative received packets of CONNECT         |
| packets/connack/sent         | Accumulative sent packets of CONNACK             |
| packets/publish/received     | Accumulative received packets of PUBLISH         |
| packets/publish/sent         | Accumulative sent packets of PUBLISH             |
| packets/publish/error        | Accumulative handling packets of PUBLISH error   |
| packets/publish/auth_error   | Accumulative denied packets of PUBLISH           |
| packets/publish/dropped      | Accumulative dropped packets of PUBLISH          |
| packets/puback/received      | Accumulative received packets of PUBACK          |
| packets/puback/sent          | Accumulative sent packets of PUBACK              |
| packets/puback/inuse         | Accumulative dropped packets of PUBACK           |
| packets/puback/missed        | Accumulative missed packets of PUBACK            |
| packets/pubrec/received      | Accumulative received packets of PUBREC          |
| packets/pubrec/sent          | Accumulative sent packets of PUBREC              |
| packets/pubrec/inuse         | Accumulative dropped packets of PUBREC           |
| packets/pubrec/missed        | Accumulative missed packets of PUBREC            |
| packets/pubrel/received      | Accumulative received packets of PUBREL          |
| packets/pubrel/sent          | Accumulative sent packets of PUBREL              |
| packets/pubrel/missed        | Accumulative missed packets of PUBREL            |
| packets/pubcomp/received     | Accumulative received packets of PUBCOMP         |
| packets/pubcomp/sent         | Accumulative sent packets of PUBCOMP             |
| packets/pubcomp/inuse        | Accumulative dropped packets of PUBCOMP          |
| packets/pubcomp/missed       | Accumulative missed packets of PUBCOMP           |
| packets/subscribe/received   | Accumulative received packets of SUBSCRIBE       |
| packets/subscribe/error      | Accumulative handling packets of SUBSCRIBE error |
| packets/subscribe/auth_error | Accumulative denied packets of SUBSCRIBE         |
| packets/suback/sent          | Accumulative sent packets of SUBACK              |
| packets/unsubscribe/received | Accumulative received packets of UNSUBSCRIBE     |
| packets/unsuback/sent        | Accumulative sent packets of UNSUBACK            |
| packets/pingreq/received     | Accumulative received packets of PINGREQ         |
| packets/pingresp/sent        | Accumulative sent packets of PINGRESP            |
| packets/disconnect/received  | Accumulative received packets of DISCONNECT      |
| packets/disconnect/sent      | Accumulative sent packets of DISCONNECT          |
| packets/auth/received        | Accumulative received packets of AUTH            |
| packets/auth/sent            | Accumulative sent packets of AUTH                |

### MQTT Sent and Received Messages Statistics

| Topic                           | Description                                      |
| ------------------------------- | ------------------------------------------------ |
| messages/received               | Accumulative received messages                   |
| messages/sent                   | Accumulative sent messages                       |
| messages/qos0/received          | Accumulative received messages of QoS 0           |
| messages/qos0/sent              | Accumulative sent messages of QoS 0               |
| messages/qos1/received          | Accumulative received messages QoS 1              |
| messages/qos1/sent              | Accumulative sent messages QoS 1                  |
| messages/qos2/received          | Accumulative received messages of QoS 2           |
| messages/qos2/sent              | Accumulative sent messages of QoS 2               |
| messages/publish                | Accumulative PUBLISH messages                    |
| messages/dropped                | Total number of dropped messages                 |
| messages/dropped/expired        | Total number of dropped messages (Expired)       |
| messages/dropped/no_subscribers | Total number of dropped messages (No subscriber) |
| messages/forward                | Total number of messages forwarded by the node   |
| messages/retained               | Accumulative retained messages                   |
| messages/delayed                | Accumulative delayed messages                    |
| messages/delivered              | Accumulative delivered messages                  |
| messages/acked                  | Accumulative acknowledged messages               |

## Alarms - System Alarms

System Topic Prefix: `$SYS/brokers/${node}/alarms/`

| Topic      | Description           |
| ---------- | --------------------- |
| activate   | newly generated alarm |
| deactivate | cleared alarm         |

## Sysmon - System Monitoring

System Topic Prefix: `$SYS/brokers/${node}/sysmon/`

| Topic          | Description                                                                                          |
| -------------- | ---------------------------------------------------------------------------------------------------- |
| long_gc        | Garbage collection takes too long                                                                    |
| long_schedule  | Process scheduling takes too long, taking up too many time slices of the scheduler                   |
| large_heap     | Process memory usage is too high                                                                     |
| busy_port      | The process sends a message to a busy port and the process is hung                                   |
| busy_dist_port | The distributed communication port used for inter-node communication is busy and the process is hung |
