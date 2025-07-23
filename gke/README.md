# GKE Autopilot + Anthos Service Mesh Terraform Module

This module provisions a production-ready GKE Autopilot cluster and registers it with Anthos Service Mesh (ASM).

## Inputs
- name: Cluster name
- region: GCP region
- project_id: GCP project ID
- network: VPC network name
- subnetwork: Subnetwork name
- ip_range_pods: Secondary range for pods
- ip_range_services: Secondary range for services

## Outputs
- cluster_name
- endpoint
- asm_membership_id

## Features
- GKE Autopilot mode (no node pools needed)
- Registers cluster with Anthos Service Mesh (ASM)
