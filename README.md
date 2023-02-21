# Overview

This repository contains samples for using Azure Stream Analytics and Azure Databricks to process change data from a relational database (also referred to as change data capture, or CDC). The intent is to provide hands-on comparison of using these two services to process CDC data in a generic manner.

# Scenario

```mermaid
flowchart LR
    subgraph Stream Ingestion Layer
        eh[Event Hub]
    end
    subgraph Stream Processing Layer
        asa[Azure Stream Analytics]
        adb[Azure Databricks]
    end
    subgraph Target Database
        asaTable[Table 1]
        adbTable[Table 2]
    end
    srcDB[(Source Database)] --change data--> eh
    eh --> asa & adb
    asa --> asaTable[Table 1]
    adb --> adbTable[Table 2]
```