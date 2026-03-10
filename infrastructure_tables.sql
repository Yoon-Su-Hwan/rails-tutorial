-- =========================================================================
-- Rails 8 Infrastructure Tables (Solid Cache, Solid Queue, Solid Cable)
-- =========================================================================
-- 이 파일은 Render 등 배포 환경에서 데이터베이스 테이블이 자동 생성되지 않을 경우,
-- DBeaver 등 DB 클라이언트를 통해 수동으로 실행하기 위한 쿼리입니다.

-- 1. Solid Cache Tables
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS solid_cache_entries (
    id bigserial PRIMARY KEY,
    key bytea NOT NULL,
    value bytea NOT NULL,
    created_at timestamptz NOT NULL,
    key_hash bigint NOT NULL,
    byte_size int NOT NULL
);
CREATE INDEX IF NOT EXISTS index_solid_cache_entries_on_key_hash_and_byte_size ON solid_cache_entries (key_hash, byte_size);
CREATE UNIQUE INDEX IF NOT EXISTS index_solid_cache_entries_on_key_hash ON solid_cache_entries (key_hash);

-- 2. Solid Queue Tables (Core)
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS solid_queue_jobs (
    id bigserial PRIMARY KEY,
    queue_name varchar NOT NULL,
    class_name varchar NOT NULL,
    arguments text,
    priority int DEFAULT 0 NOT NULL,
    active_job_id varchar,
    scheduled_at timestamptz,
    finished_at timestamptz,
    concurrency_key varchar,
    created_at timestamptz NOT NULL,
    updated_at timestamptz NOT NULL
);
CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_on_queue_name_and_priority ON solid_queue_jobs (queue_name, priority);
CREATE INDEX IF NOT EXISTS index_solid_queue_jobs_on_scheduled_at ON solid_queue_jobs (scheduled_at);

-- 3. Solid Cable Tables
-- -------------------------------------------------------------------------
CREATE TABLE IF NOT EXISTS solid_cable_messages (
    id bigserial PRIMARY KEY,
    channel varchar NOT NULL,
    payload text NOT NULL,
    created_at timestamptz NOT NULL
);
CREATE INDEX IF NOT EXISTS index_solid_cable_messages_on_channel ON solid_cable_messages (channel);


-- 기존의 잘못된 인덱스를 지우고
DROP INDEX IF EXISTS index_solid_cache_entries_on_key_hash;
-- 필요한 UNIQUE 인덱스를 다시 만듭니다.
CREATE UNIQUE INDEX index_solid_cache_entries_on_key_hash ON solid_cache_entries (key_hash);