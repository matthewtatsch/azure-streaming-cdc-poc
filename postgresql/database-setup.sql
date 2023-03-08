CREATE DATABASE streaming_cdc;

-- Create a table named "stg_document" in the "streaming_cdc" database
CREATE TABLE stg_document (
    document_id VARCHAR(255) NOT NULL UNIQUE,
    src_document_id VARCHAR(255) NOT NULL,
    src_document_created_at TIMESTAMP NOT NULL,
    asa_event_processed_utc_time TIMESTAMP NOT NULL,
    asa_event_enqueued_utc_time TIMESTAMP NOT NULL,
    note VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

-- Create "stg_coupon" table in the "streaming_cdc" database
CREATE TABLE stg_coupon (
    coupon_id VARCHAR(255) NOT NULL UNIQUE,
    document_id VARCHAR(255) NOT NULL,
    src_document_id VARCHAR(255) NOT NULL,
    src_coupon_created_at TIMESTAMP NOT NULL,
    asa_event_processed_utc_time TIMESTAMP NOT NULL,
    asa_event_enqueued_utc_time TIMESTAMP NOT NULL,
    note VARCHAR(255),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
