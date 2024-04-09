#!/usr/bin/env python3

from diagrams import Cluster, Diagram
from diagrams.aws.compute import ECS
from diagrams.aws.database import RDS
from diagrams.aws.network import ELB

# required diagrams library and Graphviz
# Reference: https://diagrams.mingrammer.com/docs/nodes/aws

with Diagram(name="Metabase", show=False):

    lb = ELB("lb")

    with Cluster("AZ-A"):
        ecs_svc_a = ECS("Metabase")

    with Cluster("AZ-B"):
        ecs_svc_b = ECS("Metabase")

    db = RDS("RDS")

    lb >> ecs_svc_a
    lb >> ecs_svc_b

    ecs_svc_a >> db
    ecs_svc_b >> db
