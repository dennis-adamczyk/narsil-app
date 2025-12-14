DROP TABLE IF EXISTS "public"."audit_logs";
-- Table Definition
CREATE TABLE "public"."audit_logs" (
    "uuid" uuid NOT NULL,
    "model_id" varchar(255) NOT NULL,
    "model_type" varchar(255) NOT NULL,
    "user_id" int8,
    "event" varchar(255) NOT NULL,
    "old_values" json,
    "new_values" json,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "audit_logs_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id"),
    PRIMARY KEY ("uuid")
);


-- Indices
CREATE INDEX audit_logs_model_id_model_type_index ON public.audit_logs USING btree (model_id, model_type);

DROP TABLE IF EXISTS "public"."block_element";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS block_element_id_seq;

-- Table Definition
CREATE TABLE "public"."block_element" (
    "id" int8 NOT NULL DEFAULT nextval('block_element_id_seq'::regclass),
    "block_id" int8 NOT NULL,
    "element_type" varchar(255) NOT NULL,
    "element_id" int8 NOT NULL,
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "description" jsonb NOT NULL DEFAULT JSON_OBJECT( RETURNING json),
    "position" int4 NOT NULL DEFAULT 0,
    "width" int2 NOT NULL DEFAULT '100'::smallint,
    CONSTRAINT "block_element_block_id_foreign" FOREIGN KEY ("block_id") REFERENCES "public"."blocks"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX block_element_element_type_element_id_index ON public.block_element USING btree (element_type, element_id);

DROP TABLE IF EXISTS "public"."block_element_conditions";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS block_element_conditions_id_seq;

-- Table Definition
CREATE TABLE "public"."block_element_conditions" (
    "id" int8 NOT NULL DEFAULT nextval('block_element_conditions_id_seq'::regclass),
    "owner_id" int8 NOT NULL,
    "target_id" int8 NOT NULL,
    "operator" varchar(255) NOT NULL,
    "value" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "block_element_conditions_owner_id_foreign" FOREIGN KEY ("owner_id") REFERENCES "public"."block_element"("id") ON DELETE CASCADE,
    CONSTRAINT "block_element_conditions_target_id_foreign" FOREIGN KEY ("target_id") REFERENCES "public"."block_element"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."blocks";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS blocks_id_seq;

-- Table Definition
CREATE TABLE "public"."blocks" (
    "id" int8 NOT NULL DEFAULT nextval('blocks_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "collapsible" bool NOT NULL DEFAULT false,
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "blocks_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "blocks_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX blocks_handle_unique ON public.blocks USING btree (handle);

DROP TABLE IF EXISTS "public"."cache";
-- Table Definition
CREATE TABLE "public"."cache" (
    "key" varchar(255) NOT NULL,
    "value" text NOT NULL,
    "expiration" int4 NOT NULL,
    PRIMARY KEY ("key")
);

DROP TABLE IF EXISTS "public"."cache_locks";
-- Table Definition
CREATE TABLE "public"."cache_locks" (
    "key" varchar(255) NOT NULL,
    "owner" varchar(255) NOT NULL,
    "expiration" int4 NOT NULL,
    PRIMARY KEY ("key")
);

DROP TABLE IF EXISTS "public"."configurations";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS configurations_id_seq;

-- Table Definition
CREATE TABLE "public"."configurations" (
    "id" int8 NOT NULL DEFAULT nextval('configurations_id_seq'::regclass),
    "default_language" varchar(255),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "configurations_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "configurations_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."event_block_fields";
-- Table Definition
CREATE TABLE "public"."event_block_fields" (
    "uuid" uuid NOT NULL,
    "block_uuid" uuid NOT NULL,
    "field_id" int8 NOT NULL,
    "value" jsonb,
    CONSTRAINT "event_block_fields_block_uuid_foreign" FOREIGN KEY ("block_uuid") REFERENCES "public"."event_blocks"("uuid") ON DELETE CASCADE,
    CONSTRAINT "event_block_fields_field_id_foreign" FOREIGN KEY ("field_id") REFERENCES "public"."fields"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."event_blocks";
-- Table Definition
CREATE TABLE "public"."event_blocks" (
    "uuid" uuid NOT NULL,
    "entity_uuid" uuid NOT NULL,
    "parent_uuid" uuid,
    "block_id" int8 NOT NULL,
    "position" int4 NOT NULL DEFAULT 0,
    CONSTRAINT "event_blocks_entity_uuid_foreign" FOREIGN KEY ("entity_uuid") REFERENCES "public"."events"("uuid") ON DELETE CASCADE,
    CONSTRAINT "event_blocks_block_id_foreign" FOREIGN KEY ("block_id") REFERENCES "public"."blocks"("id") ON DELETE CASCADE,
    CONSTRAINT "event_blocks_parent_uuid_foreign" FOREIGN KEY ("parent_uuid") REFERENCES "public"."event_blocks"("uuid") ON DELETE SET NULL,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."events";
-- Table Definition
CREATE TABLE "public"."events" (
    "uuid" uuid NOT NULL,
    "id" int8 NOT NULL,
    "slug" varchar(255) NOT NULL,
    "revision" int8 NOT NULL DEFAULT '1'::bigint,
    "published" bool NOT NULL DEFAULT false,
    "published_from" timestamp(0),
    "published_to" timestamp(0),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    "deleted_at" timestamp(0),
    "deleted_by" int8,
    "title" jsonb DEFAULT JSON_OBJECT( RETURNING json),
    CONSTRAINT "events_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "events_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "events_deleted_by_foreign" FOREIGN KEY ("deleted_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("uuid")
);


-- Indices
CREATE INDEX events_id_index ON public.events USING btree (id);
CREATE INDEX events_revision_index ON public.events USING btree (revision);
CREATE INDEX events_published_index ON public.events USING btree (published);
CREATE INDEX events_deleted_at_index ON public.events USING btree (deleted_at);

DROP TABLE IF EXISTS "public"."failed_jobs";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS failed_jobs_id_seq;

-- Table Definition
CREATE TABLE "public"."failed_jobs" (
    "id" int8 NOT NULL DEFAULT nextval('failed_jobs_id_seq'::regclass),
    "uuid" varchar(255) NOT NULL,
    "connection" text NOT NULL,
    "queue" text NOT NULL,
    "payload" text NOT NULL,
    "exception" text NOT NULL,
    "failed_at" timestamp(0) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX failed_jobs_uuid_unique ON public.failed_jobs USING btree (uuid);

DROP TABLE IF EXISTS "public"."field_block";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS field_block_id_seq;

-- Table Definition
CREATE TABLE "public"."field_block" (
    "id" int8 NOT NULL DEFAULT nextval('field_block_id_seq'::regclass),
    "block_id" int8 NOT NULL,
    "field_id" int8 NOT NULL,
    CONSTRAINT "field_block_block_id_foreign" FOREIGN KEY ("block_id") REFERENCES "public"."blocks"("id") ON DELETE CASCADE,
    CONSTRAINT "field_block_field_id_foreign" FOREIGN KEY ("field_id") REFERENCES "public"."fields"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."field_options";
-- Table Definition
CREATE TABLE "public"."field_options" (
    "uuid" uuid NOT NULL,
    "field_id" int8 NOT NULL,
    "value" varchar(255) NOT NULL,
    "label" jsonb NOT NULL,
    "position" int4 NOT NULL DEFAULT 0,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "field_options_field_id_foreign" FOREIGN KEY ("field_id") REFERENCES "public"."fields"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."field_rules";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS field_rules_id_seq;

-- Table Definition
CREATE TABLE "public"."field_rules" (
    "id" int8 NOT NULL DEFAULT nextval('field_rules_id_seq'::regclass),
    "field_id" int8 NOT NULL,
    "rule" varchar(255) NOT NULL DEFAULT 'string'::character varying,
    CONSTRAINT "field_rules_field_id_foreign" FOREIGN KEY ("field_id") REFERENCES "public"."fields"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."fields";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS fields_id_seq;

-- Table Definition
CREATE TABLE "public"."fields" (
    "id" int8 NOT NULL DEFAULT nextval('fields_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "type" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "description" jsonb NOT NULL DEFAULT JSON_OBJECT( RETURNING json),
    "translatable" bool NOT NULL DEFAULT false,
    "class_name" varchar(255),
    "settings" jsonb NOT NULL DEFAULT JSON_OBJECT( RETURNING json),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "fields_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "fields_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX fields_handle_unique ON public.fields USING btree (handle);

DROP TABLE IF EXISTS "public"."footer_legal_links";
-- Table Definition
CREATE TABLE "public"."footer_legal_links" (
    "uuid" uuid NOT NULL,
    "footer_id" int8 NOT NULL,
    "page_id" int8,
    "label" jsonb,
    "position" int4 NOT NULL DEFAULT 0,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "footer_legal_links_footer_id_foreign" FOREIGN KEY ("footer_id") REFERENCES "public"."footers"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."footer_social_links";
-- Table Definition
CREATE TABLE "public"."footer_social_links" (
    "uuid" uuid NOT NULL,
    "footer_id" int8 NOT NULL,
    "icon" varchar(255),
    "label" jsonb,
    "url" varchar(255),
    "position" int4 NOT NULL DEFAULT 0,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "footer_social_links_footer_id_foreign" FOREIGN KEY ("footer_id") REFERENCES "public"."footers"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."footers";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS footers_id_seq;

-- Table Definition
CREATE TABLE "public"."footers" (
    "id" int8 NOT NULL DEFAULT nextval('footers_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "logo" varchar(255),
    "company" varchar(255),
    "address_line_1" varchar(255),
    "address_line_2" varchar(255),
    "email" jsonb,
    "phone" varchar(255),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "footers_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "footers_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX footers_handle_unique ON public.footers USING btree (handle);

DROP TABLE IF EXISTS "public"."headers";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS headers_id_seq;

-- Table Definition
CREATE TABLE "public"."headers" (
    "id" int8 NOT NULL DEFAULT nextval('headers_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "logo" varchar(255),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "headers_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "headers_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX headers_handle_unique ON public.headers USING btree (handle);

DROP TABLE IF EXISTS "public"."host_locale_languages";
-- Table Definition
CREATE TABLE "public"."host_locale_languages" (
    "uuid" uuid NOT NULL,
    "locale_uuid" uuid,
    "language" varchar(255) NOT NULL,
    "position" int4 NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "host_locale_languages_locale_uuid_foreign" FOREIGN KEY ("locale_uuid") REFERENCES "public"."host_locales"("uuid") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."host_locales";
-- Table Definition
CREATE TABLE "public"."host_locales" (
    "uuid" uuid NOT NULL,
    "host_id" int8,
    "country" varchar(255) NOT NULL DEFAULT 'default'::character varying,
    "position" int4 NOT NULL DEFAULT 0,
    "pattern" varchar(255) NOT NULL,
    "regex" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "host_locales_host_id_foreign" FOREIGN KEY ("host_id") REFERENCES "public"."hosts"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."hosts";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS hosts_id_seq;

-- Table Definition
CREATE TABLE "public"."hosts" (
    "id" int8 NOT NULL DEFAULT nextval('hosts_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    "header_id" int8,
    "footer_id" int8,
    CONSTRAINT "hosts_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "hosts_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "hosts_header_id_foreign" FOREIGN KEY ("header_id") REFERENCES "public"."headers"("id") ON DELETE SET NULL,
    CONSTRAINT "hosts_footer_id_foreign" FOREIGN KEY ("footer_id") REFERENCES "public"."footers"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX hosts_handle_unique ON public.hosts USING btree (handle);

DROP TABLE IF EXISTS "public"."job_batches";
-- Table Definition
CREATE TABLE "public"."job_batches" (
    "id" varchar(255) NOT NULL,
    "name" varchar(255) NOT NULL,
    "total_jobs" int4 NOT NULL,
    "pending_jobs" int4 NOT NULL,
    "failed_jobs" int4 NOT NULL,
    "failed_job_ids" text NOT NULL,
    "options" text,
    "cancelled_at" int4,
    "created_at" int4 NOT NULL,
    "finished_at" int4,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."jobs";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS jobs_id_seq;

-- Table Definition
CREATE TABLE "public"."jobs" (
    "id" int8 NOT NULL DEFAULT nextval('jobs_id_seq'::regclass),
    "queue" varchar(255) NOT NULL,
    "payload" text NOT NULL,
    "attempts" int2 NOT NULL,
    "reserved_at" int4,
    "available_at" int4 NOT NULL,
    "created_at" int4 NOT NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX jobs_queue_index ON public.jobs USING btree (queue);

DROP TABLE IF EXISTS "public"."migrations";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS migrations_id_seq;

-- Table Definition
CREATE TABLE "public"."migrations" (
    "id" int4 NOT NULL DEFAULT nextval('migrations_id_seq'::regclass),
    "migration" varchar(255) NOT NULL,
    "batch" int4 NOT NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."page_block_fields";
-- Table Definition
CREATE TABLE "public"."page_block_fields" (
    "uuid" uuid NOT NULL,
    "block_uuid" uuid NOT NULL,
    "field_id" int8 NOT NULL,
    "value" jsonb,
    CONSTRAINT "page_block_fields_block_uuid_foreign" FOREIGN KEY ("block_uuid") REFERENCES "public"."page_blocks"("uuid") ON DELETE CASCADE,
    CONSTRAINT "page_block_fields_field_id_foreign" FOREIGN KEY ("field_id") REFERENCES "public"."fields"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."page_blocks";
-- Table Definition
CREATE TABLE "public"."page_blocks" (
    "uuid" uuid NOT NULL,
    "entity_uuid" uuid NOT NULL,
    "parent_uuid" uuid,
    "block_id" int8 NOT NULL,
    "position" int4 NOT NULL DEFAULT 0,
    CONSTRAINT "page_blocks_entity_uuid_foreign" FOREIGN KEY ("entity_uuid") REFERENCES "public"."pages"("uuid") ON DELETE CASCADE,
    CONSTRAINT "page_blocks_block_id_foreign" FOREIGN KEY ("block_id") REFERENCES "public"."blocks"("id") ON DELETE CASCADE,
    CONSTRAINT "page_blocks_parent_uuid_foreign" FOREIGN KEY ("parent_uuid") REFERENCES "public"."page_blocks"("uuid") ON DELETE SET NULL,
    PRIMARY KEY ("uuid")
);

DROP TABLE IF EXISTS "public"."pages";
-- Table Definition
CREATE TABLE "public"."pages" (
    "uuid" uuid NOT NULL,
    "id" int8 NOT NULL,
    "slug" varchar(255) NOT NULL,
    "revision" int8 NOT NULL DEFAULT '1'::bigint,
    "published" bool NOT NULL DEFAULT false,
    "published_from" timestamp(0),
    "published_to" timestamp(0),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    "deleted_at" timestamp(0),
    "deleted_by" int8,
    "title" jsonb DEFAULT JSON_OBJECT( RETURNING json),
    CONSTRAINT "pages_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "pages_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "pages_deleted_by_foreign" FOREIGN KEY ("deleted_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("uuid")
);


-- Indices
CREATE INDEX pages_id_index ON public.pages USING btree (id);
CREATE INDEX pages_revision_index ON public.pages USING btree (revision);
CREATE INDEX pages_published_index ON public.pages USING btree (published);
CREATE INDEX pages_deleted_at_index ON public.pages USING btree (deleted_at);

DROP TABLE IF EXISTS "public"."password_reset_tokens";
-- Table Definition
CREATE TABLE "public"."password_reset_tokens" (
    "email" varchar(255) NOT NULL,
    "token" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    PRIMARY KEY ("email")
);

DROP TABLE IF EXISTS "public"."permissions";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS permissions_id_seq;

-- Table Definition
CREATE TABLE "public"."permissions" (
    "id" int8 NOT NULL DEFAULT nextval('permissions_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "permissions_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "permissions_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX permissions_handle_unique ON public.permissions USING btree (handle);

DROP TABLE IF EXISTS "public"."relations";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS relations_id_seq;

-- Table Definition
CREATE TABLE "public"."relations" (
    "id" int8 NOT NULL DEFAULT nextval('relations_id_seq'::regclass),
    "owner_uuid" uuid NOT NULL,
    "owner_table" varchar(255) NOT NULL,
    "owner_id" int8 NOT NULL,
    "target_table" varchar(255) NOT NULL,
    "target_id" int8 NOT NULL,
    "deleted_at" timestamp(0),
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX relations_deleted_at_index ON public.relations USING btree (deleted_at);

DROP TABLE IF EXISTS "public"."role_permission";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS role_permission_id_seq;

-- Table Definition
CREATE TABLE "public"."role_permission" (
    "id" int8 NOT NULL DEFAULT nextval('role_permission_id_seq'::regclass),
    "role_id" int8 NOT NULL,
    "permission_id" int8 NOT NULL,
    CONSTRAINT "role_permission_role_id_foreign" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE,
    CONSTRAINT "role_permission_permission_id_foreign" FOREIGN KEY ("permission_id") REFERENCES "public"."permissions"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."roles";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS roles_id_seq;

-- Table Definition
CREATE TABLE "public"."roles" (
    "id" int8 NOT NULL DEFAULT nextval('roles_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "roles_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "roles_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX roles_handle_unique ON public.roles USING btree (handle);

DROP TABLE IF EXISTS "public"."sessions";
-- Table Definition
CREATE TABLE "public"."sessions" (
    "id" varchar(255) NOT NULL,
    "user_id" int8,
    "ip_address" varchar(45),
    "user_agent" text,
    "payload" text NOT NULL,
    "last_activity" int4 NOT NULL,
    CONSTRAINT "sessions_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX sessions_last_activity_index ON public.sessions USING btree (last_activity);

DROP TABLE IF EXISTS "public"."site_page_overrides";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS site_page_overrides_id_seq;

-- Table Definition
CREATE TABLE "public"."site_page_overrides" (
    "id" int8 NOT NULL DEFAULT nextval('site_page_overrides_id_seq'::regclass),
    "page_id" int8 NOT NULL,
    "country" varchar(255) NOT NULL DEFAULT 'default'::character varying,
    "parent_id" int8,
    "left_id" int8,
    "right_id" int8,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "site_page_overrides_page_id_foreign" FOREIGN KEY ("page_id") REFERENCES "public"."site_pages"("id") ON DELETE CASCADE,
    CONSTRAINT "site_page_overrides_parent_id_foreign" FOREIGN KEY ("parent_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    CONSTRAINT "site_page_overrides_left_id_foreign" FOREIGN KEY ("left_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    CONSTRAINT "site_page_overrides_right_id_foreign" FOREIGN KEY ("right_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."site_page_relations";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS site_page_relations_id_seq;

-- Table Definition
CREATE TABLE "public"."site_page_relations" (
    "id" int8 NOT NULL DEFAULT nextval('site_page_relations_id_seq'::regclass),
    "page_id" int8 NOT NULL,
    "target_table" varchar(255) NOT NULL,
    "target_id" int8 NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "site_page_relations_page_id_foreign" FOREIGN KEY ("page_id") REFERENCES "public"."site_pages"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."site_pages";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS site_pages_id_seq;

-- Table Definition
CREATE TABLE "public"."site_pages" (
    "id" int8 NOT NULL DEFAULT nextval('site_pages_id_seq'::regclass),
    "site_id" int8 NOT NULL,
    "country" varchar(255) NOT NULL DEFAULT 'default'::character varying,
    "parent_id" int8,
    "left_id" int8,
    "right_id" int8,
    "title" jsonb NOT NULL,
    "slug" jsonb NOT NULL,
    "content" jsonb,
    "meta_description" jsonb,
    "open_graph_type" varchar(255) NOT NULL DEFAULT 'website'::character varying,
    "open_graph_title" jsonb,
    "open_graph_description" jsonb,
    "open_graph_image" varchar(255),
    "robots" varchar(255) NOT NULL DEFAULT 'index, follow'::character varying,
    "change_freq" varchar(255) NOT NULL DEFAULT 'never'::character varying,
    "priority" numeric(3,2) NOT NULL DEFAULT '1'::numeric,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "site_pages_site_id_foreign" FOREIGN KEY ("site_id") REFERENCES "public"."hosts"("id") ON DELETE CASCADE,
    CONSTRAINT "site_pages_parent_id_foreign" FOREIGN KEY ("parent_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    CONSTRAINT "site_pages_left_id_foreign" FOREIGN KEY ("left_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    CONSTRAINT "site_pages_right_id_foreign" FOREIGN KEY ("right_id") REFERENCES "public"."site_pages"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."site_urls";
-- Table Definition
CREATE TABLE "public"."site_urls" (
    "uuid" uuid NOT NULL,
    "host_locale_language_uuid" uuid NOT NULL,
    "page_id" int8 NOT NULL,
    "url" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "site_urls_host_locale_language_uuid_foreign" FOREIGN KEY ("host_locale_language_uuid") REFERENCES "public"."host_locale_languages"("uuid") ON DELETE CASCADE,
    CONSTRAINT "site_urls_page_id_foreign" FOREIGN KEY ("page_id") REFERENCES "public"."site_pages"("id") ON DELETE CASCADE,
    PRIMARY KEY ("uuid")
);


-- Indices
CREATE INDEX site_urls_url_index ON public.site_urls USING btree (url);

DROP TABLE IF EXISTS "public"."template_section_element";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS template_section_element_id_seq;

-- Table Definition
CREATE TABLE "public"."template_section_element" (
    "id" int8 NOT NULL DEFAULT nextval('template_section_element_id_seq'::regclass),
    "template_section_id" int8 NOT NULL,
    "element_type" varchar(255) NOT NULL,
    "element_id" int8 NOT NULL,
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "description" jsonb NOT NULL DEFAULT JSON_OBJECT( RETURNING json),
    "position" int4 NOT NULL DEFAULT 0,
    "width" int2 NOT NULL DEFAULT '100'::smallint,
    CONSTRAINT "template_section_element_template_section_id_foreign" FOREIGN KEY ("template_section_id") REFERENCES "public"."template_sections"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX template_section_element_element_type_element_id_index ON public.template_section_element USING btree (element_type, element_id);

DROP TABLE IF EXISTS "public"."template_sections";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS template_sections_id_seq;

-- Table Definition
CREATE TABLE "public"."template_sections" (
    "id" int8 NOT NULL DEFAULT nextval('template_sections_id_seq'::regclass),
    "template_id" int8 NOT NULL,
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "position" int4 NOT NULL DEFAULT 0,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "template_sections_template_id_foreign" FOREIGN KEY ("template_id") REFERENCES "public"."templates"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."templates";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS templates_id_seq;

-- Table Definition
CREATE TABLE "public"."templates" (
    "id" int8 NOT NULL DEFAULT nextval('templates_id_seq'::regclass),
    "handle" varchar(255) NOT NULL,
    "name" jsonb NOT NULL,
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "templates_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "templates_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE UNIQUE INDEX templates_handle_unique ON public.templates USING btree (handle);

DROP TABLE IF EXISTS "public"."user_bookmarks";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_bookmarks_id_seq;

-- Table Definition
CREATE TABLE "public"."user_bookmarks" (
    "id" int8 NOT NULL DEFAULT nextval('user_bookmarks_id_seq'::regclass),
    "user_id" int8 NOT NULL,
    "name" varchar(255) NOT NULL,
    "url" varchar(255) NOT NULL,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "user_bookmarks_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."user_configurations";
-- Table Definition
CREATE TABLE "public"."user_configurations" (
    "user_id" int8 NOT NULL,
    "language" varchar(255) NOT NULL DEFAULT 'en'::character varying,
    "color" varchar(255) NOT NULL DEFAULT 'gray'::character varying,
    "radius" numeric(3,2) NOT NULL DEFAULT 0.25,
    "theme" varchar(255) NOT NULL DEFAULT 'system'::character varying,
    "preferences" jsonb,
    "created_at" timestamp(0),
    "updated_at" timestamp(0),
    CONSTRAINT "user_configurations_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE,
    PRIMARY KEY ("user_id")
);

DROP TABLE IF EXISTS "public"."user_permission";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_permission_id_seq;

-- Table Definition
CREATE TABLE "public"."user_permission" (
    "id" int8 NOT NULL DEFAULT nextval('user_permission_id_seq'::regclass),
    "user_id" int8 NOT NULL,
    "permission_id" int8 NOT NULL,
    CONSTRAINT "user_permission_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE,
    CONSTRAINT "user_permission_permission_id_foreign" FOREIGN KEY ("permission_id") REFERENCES "public"."permissions"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."user_role";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS user_role_id_seq;

-- Table Definition
CREATE TABLE "public"."user_role" (
    "id" int8 NOT NULL DEFAULT nextval('user_role_id_seq'::regclass),
    "user_id" int8 NOT NULL,
    "role_id" int8 NOT NULL,
    CONSTRAINT "user_role_user_id_foreign" FOREIGN KEY ("user_id") REFERENCES "public"."users"("id") ON DELETE CASCADE,
    CONSTRAINT "user_role_role_id_foreign" FOREIGN KEY ("role_id") REFERENCES "public"."roles"("id") ON DELETE CASCADE,
    PRIMARY KEY ("id")
);

DROP TABLE IF EXISTS "public"."users";
-- Sequence and defined type
CREATE SEQUENCE IF NOT EXISTS users_id_seq;

-- Table Definition
CREATE TABLE "public"."users" (
    "id" int8 NOT NULL DEFAULT nextval('users_id_seq'::regclass),
    "enabled" bool NOT NULL DEFAULT false,
    "last_name" varchar(255),
    "first_name" varchar(255),
    "email" varchar(255) NOT NULL,
    "email_verified_at" timestamp(0),
    "password" varchar(255) NOT NULL,
    "two_factor_secret" text,
    "two_factor_recovery_codes" text,
    "two_factor_confirmed_at" timestamp(0),
    "remember_token" varchar(100),
    "avatar" varchar(255),
    "created_at" timestamp(0) NOT NULL,
    "created_by" int8,
    "updated_at" timestamp(0) NOT NULL,
    "updated_by" int8,
    CONSTRAINT "users_created_by_foreign" FOREIGN KEY ("created_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    CONSTRAINT "users_updated_by_foreign" FOREIGN KEY ("updated_by") REFERENCES "public"."users"("id") ON DELETE SET NULL,
    PRIMARY KEY ("id")
);


-- Indices
CREATE INDEX users_enabled_index ON public.users USING btree (enabled);
CREATE UNIQUE INDEX users_email_unique ON public.users USING btree (email);

INSERT INTO "public"."audit_logs" ("uuid", "model_id", "model_type", "user_id", "event", "old_values", "new_values", "created_at", "updated_at") VALUES
('019b1d70-7c77-7198-ab64-30db159c2528', '1', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"configurations_update","name":"{\"en\":\"configurations_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":1}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c80-71b0-bdab-6d65ddd89dea', '2', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_create","name":"{\"en\":\"blocks_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":2}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c85-738d-ba66-579c1b246c79', '3', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_delete","name":"{\"en\":\"blocks_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":3}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c8a-7245-b000-7a17cf3d919d', '4', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_deleteAny","name":"{\"en\":\"blocks_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":4}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c8d-7212-a027-9e8a4698fcdb', '5', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_update","name":"{\"en\":\"blocks_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":5}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c90-73ce-89cb-63e7f2b87923', '6', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_view","name":"{\"en\":\"blocks_view\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":6}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c94-726b-9605-b6c8845fbed0', '7', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"blocks_viewAny","name":"{\"en\":\"blocks_viewAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":7}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c99-73c3-bc61-b54aa5a02195', '8', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_create","name":"{\"en\":\"fields_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":8}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7c9c-73fb-9f28-8a151168f279', '9', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_delete","name":"{\"en\":\"fields_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":9}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7ca0-738d-b8b6-a936282b7f09', '10', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_deleteAny","name":"{\"en\":\"fields_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":10}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7ca3-72eb-9b33-70fcc3c0a21c', '11', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_update","name":"{\"en\":\"fields_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":11}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7ca6-739f-bf3d-c43f5053afd8', '12', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_view","name":"{\"en\":\"fields_view\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":12}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7caa-70e9-9bf5-8aa283512b66', '13', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"fields_viewAny","name":"{\"en\":\"fields_viewAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":13}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cae-7339-9b5a-fc573ef4bf64', '14', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_create","name":"{\"en\":\"templates_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":14}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cb1-7009-9f54-e9d398fbff4f', '15', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_delete","name":"{\"en\":\"templates_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":15}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cb5-70de-8550-1854d2ba800b', '16', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_deleteAny","name":"{\"en\":\"templates_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":16}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cb9-736b-885f-08ace4a3ea99', '17', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_update","name":"{\"en\":\"templates_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":17}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cbe-716c-b5f2-c6b439ef4a51', '18', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_view","name":"{\"en\":\"templates_view\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":18}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cc3-7262-97bf-0e4838c8538a', '19', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"templates_viewAny","name":"{\"en\":\"templates_viewAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":19}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7ccd-7386-aa64-b40a162a2073', '20', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_create","name":"{\"en\":\"entities_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":20}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cd3-725e-948b-f5fe75b742f7', '21', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_delete","name":"{\"en\":\"entities_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":21}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cd9-7336-a4f1-8af1bb0dcddc', '22', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_deleteAny","name":"{\"en\":\"entities_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":22}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7ce4-70f9-8b53-92115caf81e9', '23', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_update","name":"{\"en\":\"entities_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":23}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cec-726d-82c8-215f6d970886', '24', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_view","name":"{\"en\":\"entities_view\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":24}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cf1-71be-ae60-d8e4191cc437', '25', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"entities_viewAny","name":"{\"en\":\"entities_viewAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":25}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cf6-7197-bc2d-ec9f327cc053', '26', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_create","name":"{\"en\":\"footers_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":26}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7cfc-71a0-aa2a-cfae27673a0d', '27', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_delete","name":"{\"en\":\"footers_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":27}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d03-703c-b5c6-c22495e28fa0', '28', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_deleteAny","name":"{\"en\":\"footers_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":28}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d09-7218-b2c2-9c734881bdef', '29', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_update","name":"{\"en\":\"footers_update\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":29}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d0f-72a8-91e0-b90252166153', '30', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_view","name":"{\"en\":\"footers_view\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":30}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d17-73bb-a44d-29afe9843b5c', '31', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"footers_viewAny","name":"{\"en\":\"footers_viewAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":31}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d1f-7230-b90a-90df16869a61', '32', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_create","name":"{\"en\":\"headers_create\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":32}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d25-71bd-90be-6f9a3a736900', '33', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_delete","name":"{\"en\":\"headers_delete\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":33}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d2d-71a6-9c33-1b3d93983566', '34', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_deleteAny","name":"{\"en\":\"headers_deleteAny\"}","updated_at":"2025-12-14 15:17:49","created_at":"2025-12-14 15:17:49","id":34}', '2025-12-14 15:17:49', '2025-12-14 15:17:49'),
('019b1d70-7d34-727b-9095-dea38288f00c', '35', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_update","name":"{\"en\":\"headers_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":35}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d38-72d3-ad30-0da42e533366', '36', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_view","name":"{\"en\":\"headers_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":36}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d3c-70bb-ae1e-c47191c68c3a', '37', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"headers_viewAny","name":"{\"en\":\"headers_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":37}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d40-7270-8290-3866808d00e5', '38', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_create","name":"{\"en\":\"hosts_create\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":38}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d44-7095-a16f-21f8c04367ab', '39', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_delete","name":"{\"en\":\"hosts_delete\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":39}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d47-7127-9817-8a298dd942eb', '40', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_deleteAny","name":"{\"en\":\"hosts_deleteAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":40}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d4a-72a4-9c8e-1284d1ac96a7', '41', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_update","name":"{\"en\":\"hosts_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":41}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d4e-7149-b9e0-dc826b5a1cd7', '42', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_view","name":"{\"en\":\"hosts_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":42}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d51-725d-9a8f-cf9061cf3987', '43', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"hosts_viewAny","name":"{\"en\":\"hosts_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":43}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d55-72ec-9e4e-8ef315c73888', '44', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"permissions_update","name":"{\"en\":\"permissions_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":44}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d58-7119-ac25-afd3012232f0', '45', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"permissions_view","name":"{\"en\":\"permissions_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":45}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d5b-71c0-805c-9ec478767275', '46', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"permissions_viewAny","name":"{\"en\":\"permissions_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":46}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d5f-73ae-bb09-5930ff9e8db2', '47', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_create","name":"{\"en\":\"roles_create\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":47}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d63-7192-b97f-a2ea2434f534', '48', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_delete","name":"{\"en\":\"roles_delete\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":48}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d66-70f1-83b8-3fa8d49cad8c', '49', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_deleteAny","name":"{\"en\":\"roles_deleteAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":49}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d69-7014-ab01-e62186d389ca', '50', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_update","name":"{\"en\":\"roles_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":50}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d6c-731c-8659-806423617284', '51', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_view","name":"{\"en\":\"roles_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":51}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d70-7004-8040-5fa5ef5c46b7', '52', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"roles_viewAny","name":"{\"en\":\"roles_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":52}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d75-73c0-b857-3e2a532c8c6a', '53', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"sites_update","name":"{\"en\":\"sites_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":53}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d78-70c5-a071-e7590333540c', '54', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"sites_view","name":"{\"en\":\"sites_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":54}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d7b-7254-9587-6022e4d21508', '55', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"sites_viewAny","name":"{\"en\":\"sites_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":55}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d7f-7027-a6b9-aa2646b9ebf7', '56', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_create","name":"{\"en\":\"site_pages_create\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":56}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d83-726e-bf48-c9e9af852be2', '57', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_delete","name":"{\"en\":\"site_pages_delete\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":57}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d86-7136-982b-0089ee8d75a1', '58', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_deleteAny","name":"{\"en\":\"site_pages_deleteAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":58}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d8a-70b5-a593-fbc89b9eeea2', '59', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_update","name":"{\"en\":\"site_pages_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":59}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d8e-7077-b575-e3111f80c692', '60', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_view","name":"{\"en\":\"site_pages_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":60}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d93-72a3-b5e0-209f95f06cb1', '61', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"site_pages_viewAny","name":"{\"en\":\"site_pages_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":61}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d98-73b7-ba63-1fcbcd764e72', '62', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_create","name":"{\"en\":\"users_create\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":62}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d9b-73c1-ab0c-387c09cb3b81', '63', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_delete","name":"{\"en\":\"users_delete\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":63}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7d9f-730f-a5fc-b9b9418346e8', '64', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_deleteAny","name":"{\"en\":\"users_deleteAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":64}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7da3-72da-962c-f6a77cf4b011', '65', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_update","name":"{\"en\":\"users_update\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":65}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7da8-7149-9485-950a0d7aba80', '66', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_view","name":"{\"en\":\"users_view\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":66}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dab-7374-9bb0-8d38b1f44b86', '67', 'Narsil\Models\Policies\Permission', NULL, 'created', '[]', '{"handle":"users_viewAny","name":"{\"en\":\"users_viewAny\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":67}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dbd-7105-906d-dba77ab426c2', '1', 'Narsil\Models\Globals\Footer', NULL, 'created', '[]', '{"company":"Mohr and Sons","address_line_1":"78747 Barton Crossroad","address_line_2":"66144 East Candelariostad","email":"{\"en\":\"ottilie.stark@example.org\"}","handle":"ex-omnis-dolore-ducimus-labore","phone":"234.736.4407","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":1}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dc4-725f-baec-2c4bcaae832c', '019b1d70-7dc2-7256-a3cc-5cd279dfe4a5', 'Narsil\Models\Globals\FooterSocialLink', NULL, 'created', '[]', '{"footer_id":1,"icon":"linkedin","label":"{\"en\":\"LinkedIn\"}","position":0,"url":"https:\/\/linkedin.com","uuid":"019b1d70-7dc2-7256-a3cc-5cd279dfe4a5","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dc8-7072-b4ba-f9a3ca8227e7', '019b1d70-7dc7-7360-b739-eee260852858', 'Narsil\Models\Globals\FooterSocialLink', NULL, 'created', '[]', '{"footer_id":1,"icon":"instagram","label":"{\"en\":\"Instagram\"}","position":1,"url":"https:\/\/instagram.com","uuid":"019b1d70-7dc7-7360-b739-eee260852858","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dcc-735a-8c09-392480c94a0e', '1', 'Narsil\Models\Sites\Site', NULL, 'created', '[]', '{"handle":"narsil-app.ddev.site","name":"{\"en\":\"narsil-app.ddev.site\"}","footer_id":1,"updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":1}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7de6-728a-9657-6f7ee6e1abd7', '019b1d70-7de3-70d3-8c70-bbfd1e934399', 'Narsil\Models\Hosts\HostLocale', NULL, 'created', '[]', '{"host_id":1,"country":"default","pattern":"https:\/\/{host}\/{language}","position":0,"regex":"#^https\\:\/\/(?P<host>[^\/]+)\/(?P<language>[a-z]{2})(?:\/(?P<path>.*))?$#i","uuid":"019b1d70-7de3-70d3-8c70-bbfd1e934399","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dec-7205-8dfd-8ec9ef58624f', '019b1d70-7de9-7158-9366-794f33f513e5', 'Narsil\Models\Hosts\HostLocaleLanguage', NULL, 'created', '[]', '{"locale_uuid":"019b1d70-7de3-70d3-8c70-bbfd1e934399","language":"en","position":0,"uuid":"019b1d70-7de9-7158-9366-794f33f513e5","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7def-734a-be81-e208f30204b1', '019b1d70-7ded-73d9-8dbe-1ca5a72aa037', 'Narsil\Models\Hosts\HostLocaleLanguage', NULL, 'created', '[]', '{"locale_uuid":"019b1d70-7de3-70d3-8c70-bbfd1e934399","language":"de","position":1,"uuid":"019b1d70-7ded-73d9-8dbe-1ca5a72aa037","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7df2-7309-b08e-78b1141a3576', '019b1d70-7df0-7042-9bbc-09074e1087ce', 'Narsil\Models\Hosts\HostLocaleLanguage', NULL, 'created', '[]', '{"locale_uuid":"019b1d70-7de3-70d3-8c70-bbfd1e934399","language":"fr","position":2,"uuid":"019b1d70-7df0-7042-9bbc-09074e1087ce","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50"}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dfa-7117-b647-ee7420302ec9', '1', 'Narsil\Models\Policies\Role', NULL, 'created', '[]', '{"handle":"super_admin","name":"{\"en\":\"Super Admin\"}","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":1}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7eb4-7204-9732-b046273504f7', '1', 'Narsil\Models\User', NULL, 'created', '[]', '{"email":"admin@narsil.io","first_name":"Admin","last_name":"Super","email_verified_at":"2025-12-14 15:17:50","password":"$2y$12$TCF\/BgdOwyVAc3yDzYPfOOnq55k\/2M24TijHpUpxHtmYaud9j35ny","updated_at":"2025-12-14 15:17:50","created_at":"2025-12-14 15:17:50","id":1}', '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-c4a7-739a-a36f-674fb7b2be20', '1', 'Narsil\Models\Elements\Template', 1, 'created', '[]', '{"handle":"events","name":"{\"en\":\"Events\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":1}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c4d3-73a7-b1a3-2e1508150f1e', '68', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"events_view","name":"{\"en\":\"events_view\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":68}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c4d6-70a2-8fc4-033cff14e4d8', '69', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"events_create","name":"{\"en\":\"events_create\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":69}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c4da-7144-a467-5f1361c92ab9', '70', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"events_update","name":"{\"en\":\"events_update\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":70}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c4dd-70cb-a639-c2cae0c762fc', '71', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"events_delete","name":"{\"en\":\"events_delete\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":71}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c4e1-720f-8602-96a5e9cb6962', '1', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"title","name":"{\"en\":\"Title\"}","settings":"{\"value\":\"\",\"type\":\"text\",\"required\":true}","translatable":true,"type":"Narsil\\Contracts\\Fields\\TextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":1}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c503-7293-8949-69c6205a5fde', '2', 'Narsil\Models\Elements\Template', 1, 'created', '[]', '{"handle":"pages","name":"{\"en\":\"Pages\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":2}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c52b-71c7-90a8-19f554517a9e', '72', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"pages_view","name":"{\"en\":\"pages_view\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":72}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c531-70b7-a1ac-a06ea843504f', '73', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"pages_create","name":"{\"en\":\"pages_create\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":73}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c537-7003-bcea-a1f9e97f98ca', '74', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"pages_update","name":"{\"en\":\"pages_update\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":74}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c53c-73aa-baf9-0bc3e6e2d92f', '75', 'Narsil\Models\Policies\Permission', 1, 'created', '[]', '{"handle":"pages_delete","name":"{\"en\":\"pages_delete\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":75}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c54f-72d4-ad48-d63ad0ea910c', '1', 'Narsil\Models\Elements\Block', 1, 'created', '[]', '{"handle":"accordion","name":"{\"en\":\"Accordion\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":1}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c553-715b-b434-971c1001d8ce', '2', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"accordion-builder","name":"{\"en\":\"Items\"}","settings":"{}","translatable":false,"type":"Narsil\\Contracts\\Fields\\BuilderField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":2}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c557-7245-a746-1fd96ad43d71', '2', 'Narsil\Models\Elements\Block', 1, 'created', '[]', '{"handle":"accordion-item","name":"{\"en\":\"Accordion Item\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":2}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c55b-708d-aa52-4bfce28cc91b', '3', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"accordion-item-trigger","name":"{\"en\":\"Trigger\"}","settings":"{}","translatable":true,"type":"Narsil\\Contracts\\Fields\\TextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":3}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c560-72aa-9537-e969179a929f', '4', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"accordion-item-content","name":"{\"en\":\"Content\"}","settings":"{}","translatable":true,"type":"Narsil\\Contracts\\Fields\\RichTextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":4}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c569-7160-a25a-607b2c73c1ac', '3', 'Narsil\Models\Elements\Block', 1, 'created', '[]', '{"handle":"headline","name":"{\"en\":\"Headline\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":3}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c56c-7053-9a2b-35aabd8c84f8', '5', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"headline","name":"{\"en\":\"Headline\"}","settings":"{\"value\":\"\",\"required\":true}","translatable":true,"type":"Narsil\\Contracts\\Fields\\TextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":5}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c570-72b7-a0de-72cc79f0f353', '6', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"headline-level","name":"{\"en\":\"Level\"}","settings":"{\"value\":\"h1\",\"required\":true}","translatable":false,"type":"Narsil\\Contracts\\Fields\\SelectField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":6}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c57e-7172-8fda-35fc8ce0e64a', '7', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"headline-style","name":"{\"en\":\"Style\"}","settings":"{\"value\":\"h6\",\"required\":true}","translatable":false,"type":"Narsil\\Contracts\\Fields\\SelectField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":7}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c58c-71ab-8eab-ea6760653e2f', '4', 'Narsil\Models\Elements\Block', 1, 'created', '[]', '{"handle":"hero-header","name":"{\"en\":\"Hero Header\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":4}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c593-734e-8f87-519d3cbb4ede', '8', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"excerpt","name":"{\"en\":\"Excerpt\"}","settings":"{}","translatable":false,"type":"Narsil\\Contracts\\Fields\\RichTextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":8}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c599-7170-b41a-cd9c4d97e953', '9', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"url","name":"{\"en\":\"URL\"}","settings":"{}","translatable":false,"type":"Narsil\\Contracts\\Fields\\TextField","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":9}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c59e-72a6-b480-7594bb57a9b3', '10', 'Narsil\Models\Elements\Field', 1, 'created', '[]', '{"handle":"content","type":"Narsil\\Contracts\\Fields\\BuilderField","name":"{\"en\":\"Content\"}","created_by":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08","id":10}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5db-72ee-9ddb-d224d4680b28', '019b1d70-c5d9-7055-a473-0f1812ac6779', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"nesciunt\"}","title":"{\"en\":\"qui molestias quia\"}","uuid":"019b1d70-c5d9-7055-a473-0f1812ac6779","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5e0-72ac-8d12-69f151aca200', '019b1d70-c5de-70d3-8efa-161199967ae2', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":2,"slug":"{\"en\":\"quam-blanditiis\"}","title":"{\"en\":\"aspernatur illum quia\"}","uuid":"019b1d70-c5de-70d3-8efa-161199967ae2","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5e4-736a-946c-b8026d331b03', '019b1d70-c5e2-7227-9d0b-00d74c0c6748', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":3,"slug":"{\"en\":\"dolorem\"}","title":"{\"en\":\"eum animi veniam\"}","uuid":"019b1d70-c5e2-7227-9d0b-00d74c0c6748","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5e7-72ee-b32b-b28c43303953', '019b1d70-c5e6-7045-b5d2-03b3282fe694', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":4,"slug":"{\"en\":\"quidem-corporis\"}","title":"{\"en\":\"deserunt amet eligendi\"}","uuid":"019b1d70-c5e6-7045-b5d2-03b3282fe694","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5eb-71de-93fc-9caadfaf8e66', '019b1d70-c5e9-71b5-b296-7d1445f3433e', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":5,"slug":"{\"en\":\"cupiditate-magnam\"}","title":"{\"en\":\"omnis quo eum\"}","uuid":"019b1d70-c5e9-71b5-b296-7d1445f3433e","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5ee-7187-8abc-48dd151bbb1e', '019b1d70-c5ed-72e1-ad86-4e0cbe52cfa3', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":6,"slug":"{\"en\":\"iusto\"}","title":"{\"en\":\"dolor fugit dolores\"}","uuid":"019b1d70-c5ed-72e1-ad86-4e0cbe52cfa3","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5f2-72aa-a406-38bd639d795b', '019b1d70-c5f0-7007-8922-4195033cf012', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":7,"slug":"{\"en\":\"et-velit\"}","title":"{\"en\":\"et laboriosam consequuntur\"}","uuid":"019b1d70-c5f0-7007-8922-4195033cf012","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5f5-705a-938c-835f059ff752', '019b1d70-c5f4-736a-b3d8-c22c6c79901e', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":8,"slug":"{\"en\":\"sunt\"}","title":"{\"en\":\"aperiam doloribus blanditiis\"}","uuid":"019b1d70-c5f4-736a-b3d8-c22c6c79901e","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5f7-7267-882a-9cd0fb88bda1', '019b1d70-c5f6-70e7-84be-9815f3fcc461', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":9,"slug":"{\"en\":\"cum-autem\"}","title":"{\"en\":\"nihil placeat beatae\"}","uuid":"019b1d70-c5f6-70e7-84be-9815f3fcc461","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5fa-70ef-a05f-36c5666d553b', '019b1d70-c5f9-7287-b672-d5964b6ea7f9', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":10,"slug":"{\"en\":\"sint-sit\"}","title":"{\"en\":\"dicta veniam et\"}","uuid":"019b1d70-c5f9-7287-b672-d5964b6ea7f9","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c5fd-707a-a2cf-0c9a9bfbcab3', '019b1d70-c5fb-71ff-89c5-24102fab7f74', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-inventore\"}","title":"{\"en\":\"tempore nihil ut\"}","uuid":"019b1d70-c5fb-71ff-89c5-24102fab7f74","created_by":1,"revision":1,"updated_at":"2025-12-14 15:18:08","created_at":"2025-12-14 15:18:08"}', '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-d37f-7259-ac24-9778dd9d849a', '1', 'Narsil\Models\Configuration', 1, 'created', '[]', '{"created_by":1,"updated_at":"2025-12-14 15:18:12","created_at":"2025-12-14 15:18:12","id":1}', '2025-12-14 15:18:12', '2025-12-14 15:18:12'),
('019b1d70-de8b-73c5-a903-d214d22a6a1a', '019b1d70-de88-72d4-acc5-cfc900027918', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"nesciunt\"}","revision":-1,"published":false,"published_from":"2025-12-08T00:00","published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"qui molestias quia\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:18:14","uuid":"019b1d70-de88-72d4-acc5-cfc900027918"}', '2025-12-14 15:18:14', '2025-12-14 15:18:14'),
('019b1d70-ec9f-7315-bfc4-b3d7ddf3884c', '019b1d70-de88-72d4-acc5-cfc900027918', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"nesciunt\"}","revision":-1,"published":false,"published_from":"2025-12-08T03:04","published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"qui molestias quia\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:18:18","uuid":"019b1d70-de88-72d4-acc5-cfc900027918"}', '2025-12-14 15:18:18', '2025-12-14 15:18:18'),
('019b1d70-ef89-71b0-9f73-9ce1d0558d34', '019b1d70-ef87-7353-983e-4c8b04307561', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"nesciunt\"}","revision":2,"published":false,"published_from":"2025-12-08T03:04","published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"qui molestias quia\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:18:19","uuid":"019b1d70-ef87-7353-983e-4c8b04307561"}', '2025-12-14 15:18:19', '2025-12-14 15:18:19'),
('019b1d70-ef90-7239-8c6d-0c3176b23c55', '019b1d70-c5d9-7055-a473-0f1812ac6779', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:18:19","deleted_by":1}', '{"updated_at":"2025-12-14 15:18:19","deleted_by":1}', '2025-12-14 15:18:19', '2025-12-14 15:18:19'),
('019b1d74-1a54-72f4-b22c-adbf97f3e2d9', '019b1d74-1a4f-7144-b3b6-66c25b837565', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-inventore\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:21:46","uuid":"019b1d74-1a4f-7144-b3b6-66c25b837565"}', '2025-12-14 15:21:46', '2025-12-14 15:21:46'),
('019b1d74-35be-723e-9afe-1bee085b619a', '019b1d74-1a4f-7144-b3b6-66c25b837565', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-inventore\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:21:53","uuid":"019b1d74-1a4f-7144-b3b6-66c25b837565"}', '2025-12-14 15:21:53', '2025-12-14 15:21:53'),
('019b1d74-3cf6-717c-994c-9920a7abd16a', '019b1d74-3cf3-72f9-b9ba-c53ff6297e83', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-inventore\"}","revision":2,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:21:55","uuid":"019b1d74-3cf3-72f9-b9ba-c53ff6297e83"}', '2025-12-14 15:21:55', '2025-12-14 15:21:55'),
('019b1d74-3cfc-72e0-8406-4ce7d46f8ceb', '019b1d70-c5fb-71ff-89c5-24102fab7f74', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:21:55","deleted_by":1}', '{"updated_at":"2025-12-14 15:21:55","deleted_by":1}', '2025-12-14 15:21:55', '2025-12-14 15:21:55'),
('019b1d77-015d-713d-bda1-8b04d2b6250b', '019b1d77-015a-72d1-8fb3-1edcacce2c89', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:24:57","uuid":"019b1d77-015a-72d1-8fb3-1edcacce2c89"}', '2025-12-14 15:24:57', '2025-12-14 15:24:57'),
('019b1d77-0196-71bc-b57b-7624b3c90c77', '019b1d77-0193-70fb-83ae-2e555f900eba', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":3,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:24:57","uuid":"019b1d77-0193-70fb-83ae-2e555f900eba"}', '2025-12-14 15:24:57', '2025-12-14 15:24:57'),
('019b1d77-019e-71ce-93b5-70155d972609', '019b1d74-3cf3-72f9-b9ba-c53ff6297e83', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:24:57","deleted_by":1}', '{"updated_at":"2025-12-14 15:24:57","deleted_by":1}', '2025-12-14 15:24:57', '2025-12-14 15:24:57'),
('019b1d77-382e-710b-9ba6-4191e5ca3f2a', '019b1d77-382b-7305-a8c0-737f3ad44d52', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":2,"slug":"{\"en\":\"dolorem\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"aspernatur illum quia\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:25:11","uuid":"019b1d77-382b-7305-a8c0-737f3ad44d52"}', '2025-12-14 15:25:11', '2025-12-14 15:25:11'),
('019b1d77-398f-7342-9e75-e15c35317420', '019b1d77-398c-7258-87e3-d4d60eadacbd', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":2,"slug":"{\"en\":\"dolorem\"}","revision":2,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"aspernatur illum quia\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:25:11","uuid":"019b1d77-398c-7258-87e3-d4d60eadacbd"}', '2025-12-14 15:25:11', '2025-12-14 15:25:11'),
('019b1d77-3995-73b4-bd92-ba4dabbaafb9', '019b1d70-c5de-70d3-8efa-161199967ae2', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:25:11","deleted_by":1}', '{"updated_at":"2025-12-14 15:25:11","deleted_by":1}', '2025-12-14 15:25:11', '2025-12-14 15:25:11'),
('019b1d78-a5e4-717f-881e-12b2a05859f0', '019b1d78-a5e0-73ff-be3e-bf258ffe72b2', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":3,"slug":"{\"en\":\"dolor\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"eum animi veniam\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:26:44","uuid":"019b1d78-a5e0-73ff-be3e-bf258ffe72b2"}', '2025-12-14 15:26:44', '2025-12-14 15:26:44'),
('019b1d79-45e3-7006-820e-0349cf9f3164', '019b1d79-45df-72ef-89c6-bd4ea2a0340b', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":3,"slug":"{\"en\":\"dolor\"}","revision":2,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"eum animi veniam\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:27:25","uuid":"019b1d79-45df-72ef-89c6-bd4ea2a0340b"}', '2025-12-14 15:27:25', '2025-12-14 15:27:25'),
('019b1d79-45ec-72fb-a8f8-b38a30f155b1', '019b1d70-c5e2-7227-9d0b-00d74c0c6748', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:27:25","deleted_by":1}', '{"updated_at":"2025-12-14 15:27:25","deleted_by":1}', '2025-12-14 15:27:25', '2025-12-14 15:27:25'),
('019b1d79-5919-737a-bb8b-2202d771c5e3', '019b1d79-5916-7082-9b1f-628fef90f8b6', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":3,"slug":"{\"en\":\"dolorem\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"eum animi veniam\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:27:30","uuid":"019b1d79-5916-7082-9b1f-628fef90f8b6"}', '2025-12-14 15:27:30', '2025-12-14 15:27:30'),
('019b1d79-615b-73cc-965e-2cb4626b1544', '019b1d79-6158-70ce-bbff-3d971a08d5df', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":3,"slug":"{\"en\":\"dolorem\"}","revision":3,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"eum animi veniam\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 15:27:32","uuid":"019b1d79-6158-70ce-bbff-3d971a08d5df"}', '2025-12-14 15:27:32', '2025-12-14 15:27:32'),
('019b1d79-6161-7208-bcca-f47489aee0a4', '019b1d79-45df-72ef-89c6-bd4ea2a0340b', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 15:27:32","deleted_by":1}', '{"updated_at":"2025-12-14 15:27:32","deleted_by":1}', '2025-12-14 15:27:32', '2025-12-14 15:27:32'),
('019b1d7d-33d3-73f2-884e-a29a58ff693f', '019b1d7d-33d0-71a6-a3bc-49ee29b08a44', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"slug":"{\"en\":\"test\"}","title":"{\"en\":\"test\"}","published_from":null,"published_to":null,"uuid":"019b1d7d-33d0-71a6-a3bc-49ee29b08a44","created_by":1,"id":2,"revision":1,"updated_at":"2025-12-14 15:31:43","created_at":"2025-12-14 15:31:43"}', '2025-12-14 15:31:43', '2025-12-14 15:31:43'),
('019b1dd2-0a15-736a-9302-84823ae07379', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:23","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:23', '2025-12-14 17:04:23'),
('019b1dd2-123c-721a-acc0-4316c268b651', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:25","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:25', '2025-12-14 17:04:25'),
('019b1dd2-1972-721c-b4e9-6951d0a05112', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:26","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:26', '2025-12-14 17:04:26'),
('019b1dd2-25dd-7056-9039-4d11e0bdd8bc', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:30","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:30', '2025-12-14 17:04:30'),
('019b1dd2-2d4b-7171-86a1-8d1931f87386', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:32","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:32', '2025-12-14 17:04:32'),
('019b1dd2-32dd-7024-8833-888c2d8cd98a', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:33","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:33', '2025-12-14 17:04:33'),
('019b1dd2-3cb4-7289-9484-5e82b09faa06', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:36","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:36', '2025-12-14 17:04:36'),
('019b1dd2-466a-706b-951c-765d92c68b5a', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:38","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:38', '2025-12-14 17:04:38'),
('019b1dd2-4a6e-72ab-a185-fb0299a1df0a', '019b1dd2-0a0f-729b-96dc-501f997d6370', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:39","uuid":"019b1dd2-0a0f-729b-96dc-501f997d6370"}', '2025-12-14 17:04:39', '2025-12-14 17:04:39'),
('019b1dd2-4fda-7141-9156-84b3987b2116', '019b1dd2-4fd8-733a-9ae3-dd021165e006', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":4,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:04:40","uuid":"019b1dd2-4fd8-733a-9ae3-dd021165e006"}', '2025-12-14 17:04:40', '2025-12-14 17:04:40'),
('019b1dd2-5088-721c-8438-66ea3bef802c', '019b1d77-0193-70fb-83ae-2e555f900eba', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 17:04:41","deleted_by":1}', '{"updated_at":"2025-12-14 17:04:41","deleted_by":1}', '2025-12-14 17:04:41', '2025-12-14 17:04:41'),
('019b1df9-1509-709d-959d-383ba50df819', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:01","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:01', '2025-12-14 17:47:01'),
('019b1df9-244f-718a-a28e-b4f9519e2138', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:05","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:05', '2025-12-14 17:47:05'),
('019b1df9-3e92-721b-ae5f-94fe08cde248', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:12","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:12', '2025-12-14 17:47:12'),
('019b1df9-4df0-7200-9c39-97676e59fecc', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:16","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:16', '2025-12-14 17:47:16'),
('019b1df9-6c22-7373-be26-8d71567bab83', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:24","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:24', '2025-12-14 17:47:24'),
('019b1df9-709b-70fe-b061-a8341d1c2ad7', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:25","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:25', '2025-12-14 17:47:25'),
('019b1df9-7cb3-7257-96b9-424140a11b6d', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:28","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:28', '2025-12-14 17:47:28'),
('019b1df9-8fcd-7201-a7a8-89f77390c3f4', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:33","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:33', '2025-12-14 17:47:33'),
('019b1df9-9c6d-73c6-ab94-e6c09bfa6ec5', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:36","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:36', '2025-12-14 17:47:36'),
('019b1df9-c0f3-71b2-a3e4-11d42f8003b8', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:45","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:45', '2025-12-14 17:47:45'),
('019b1df9-c547-71cc-a504-7f6a330f91d4', '019b1df9-1505-732b-912a-5985a1c3c9b7', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:46","uuid":"019b1df9-1505-732b-912a-5985a1c3c9b7"}', '2025-12-14 17:47:46', '2025-12-14 17:47:46'),
('019b1df9-c67c-7365-99a3-b8d2ad8901fb', '019b1df9-c67a-72eb-a820-13f21013d830', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":5,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 17:47:47","uuid":"019b1df9-c67a-72eb-a820-13f21013d830"}', '2025-12-14 17:47:47', '2025-12-14 17:47:47'),
('019b1df9-c721-721b-a018-6dc8ff271b36', '019b1dd2-4fd8-733a-9ae3-dd021165e006', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 17:47:47","deleted_by":1}', '{"updated_at":"2025-12-14 17:47:47","deleted_by":1}', '2025-12-14 17:47:47', '2025-12-14 17:47:47'),
('019b1e10-3a70-701b-ba2f-041f38dab087', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:18","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:18', '2025-12-14 18:12:18'),
('019b1e10-5de6-7091-960e-90181e399382', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:27","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:27', '2025-12-14 18:12:27'),
('019b1e10-6671-73d9-b6d3-5b3f9750c71d', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:29","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:29', '2025-12-14 18:12:29'),
('019b1e10-6f64-73a2-aa7c-7a58aca93dc5', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:32","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:32', '2025-12-14 18:12:32'),
('019b1e10-7533-7077-9665-baafe5d48892', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:33","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:33', '2025-12-14 18:12:33'),
('019b1e10-7a3d-7133-9a89-6f32cd4f5bd7', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:34","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:35', '2025-12-14 18:12:35'),
('019b1e10-a313-72db-b386-b129d598a6d0', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:45","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:45', '2025-12-14 18:12:45'),
('019b1e10-c8bb-7201-bc7b-ec37cc54da6f', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:12:55","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:12:55', '2025-12-14 18:12:55'),
('019b1e10-e0ed-7219-b1cb-0136c8800a02', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:13:01","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:13:01', '2025-12-14 18:13:01'),
('019b1e10-e5ef-7061-ac88-b3d0c01b56f6', '019b1e10-3a6c-71a9-a4f3-dfb076da107f', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:13:02","uuid":"019b1e10-3a6c-71a9-a4f3-dfb076da107f"}', '2025-12-14 18:13:02', '2025-12-14 18:13:02'),
('019b1e10-ebcf-7312-ba14-2ca0c5ceb8a5', '019b1e10-ebcd-7143-b730-5f73a1068dff', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":6,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:13:04","uuid":"019b1e10-ebcd-7143-b730-5f73a1068dff"}', '2025-12-14 18:13:04', '2025-12-14 18:13:04'),
('019b1e10-ecb7-72d0-a2cc-dc8ca1ba9cf2', '019b1df9-c67a-72eb-a820-13f21013d830', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 18:13:04","deleted_by":1}', '{"updated_at":"2025-12-14 18:13:04","deleted_by":1}', '2025-12-14 18:13:04', '2025-12-14 18:13:04'),
('019b1e16-1ff9-70d4-8198-ab4baf2fde4e', '019b1e16-1ff5-7249-85c6-cee442f2faad', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:18:45","uuid":"019b1e16-1ff5-7249-85c6-cee442f2faad"}', '2025-12-14 18:18:45', '2025-12-14 18:18:45'),
('019b1e16-2df0-721a-8463-1527845da754', '019b1e16-1ff5-7249-85c6-cee442f2faad', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:18:48","uuid":"019b1e16-1ff5-7249-85c6-cee442f2faad"}', '2025-12-14 18:18:48', '2025-12-14 18:18:48'),
('019b1e16-7ea7-73f4-90e2-45c33ddec118', '019b1e16-1ff5-7249-85c6-cee442f2faad', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:19:09","uuid":"019b1e16-1ff5-7249-85c6-cee442f2faad"}', '2025-12-14 18:19:09', '2025-12-14 18:19:09'),
('019b1e16-83e7-715e-9e3a-738d8864ae57', '019b1e16-1ff5-7249-85c6-cee442f2faad', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:19:10","uuid":"019b1e16-1ff5-7249-85c6-cee442f2faad"}', '2025-12-14 18:19:10', '2025-12-14 18:19:10'),
('019b1e16-88c4-7384-b615-e1d0ca4f86c0', '019b1e16-1ff5-7249-85c6-cee442f2faad', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":-1,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:19:11","uuid":"019b1e16-1ff5-7249-85c6-cee442f2faad"}', '2025-12-14 18:19:11', '2025-12-14 18:19:11'),
('019b1e16-8e52-7183-8ffe-e56f79e57bb8', '019b1e16-8e50-71ed-aaa2-7f50edd46fe6', 'Narsil\Models\Entities\Entity', 1, 'created', '[]', '{"id":1,"slug":"{\"en\":\"quasi-invento\",\"fr\":\"quasi-invento-fr\"}","revision":7,"published":false,"published_from":null,"published_to":null,"created_by":1,"updated_by":1,"deleted_at":null,"deleted_by":null,"title":"{\"en\":\"tempore nihil ut\"}","created_at":"2025-12-14 15:18:08","updated_at":"2025-12-14 18:19:13","uuid":"019b1e16-8e50-71ed-aaa2-7f50edd46fe6"}', '2025-12-14 18:19:13', '2025-12-14 18:19:13'),
('019b1e16-8f3d-7183-8179-6cd87f2385a4', '019b1e10-ebcd-7143-b730-5f73a1068dff', 'Narsil\Models\Entities\Entity', 1, 'deleted', '{"updated_at":"2025-12-14 18:19:13","deleted_by":1}', '{"updated_at":"2025-12-14 18:19:13","deleted_by":1}', '2025-12-14 18:19:13', '2025-12-14 18:19:13');
INSERT INTO "public"."block_element" ("id", "block_id", "element_type", "element_id", "handle", "name", "description", "position", "width") VALUES
(1, 2, 'Narsil\Models\Elements\Field', 3, 'accordion-item-trigger', '{"en": "Trigger"}', '{}', 0, 100),
(2, 2, 'Narsil\Models\Elements\Field', 4, 'accordion-item-content', '{"en": "Content"}', '{}', 1, 100),
(3, 1, 'Narsil\Models\Elements\Field', 2, 'accordion-builder', '{"en": "Items"}', '{}', 0, 100),
(4, 3, 'Narsil\Models\Elements\Field', 5, 'headline', '{"en": "Headline"}', '{}', 0, 100),
(5, 3, 'Narsil\Models\Elements\Field', 6, 'headline-level', '{"en": "Level"}', '{}', 1, 50),
(6, 3, 'Narsil\Models\Elements\Field', 7, 'headline-style', '{"en": "Style"}', '{}', 2, 50),
(7, 4, 'Narsil\Models\Elements\Field', 5, 'headline', '{"en": "Headline"}', '{}', 0, 100),
(8, 4, 'Narsil\Models\Elements\Field', 8, 'excerpt', '{"en": "Excerpt"}', '{}', 1, 100),
(9, 4, 'Narsil\Models\Elements\Field', 9, 'url', '{"en": "URL"}', '{}', 2, 100);

INSERT INTO "public"."blocks" ("id", "handle", "name", "collapsible", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'accordion', '{"en": "Accordion"}', 'f', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(2, 'accordion-item', '{"en": "Accordion Item"}', 'f', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(3, 'headline', '{"en": "Headline"}', 'f', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(4, 'hero-header', '{"en": "Hero Header"}', 'f', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL);
INSERT INTO "public"."cache" ("key", "value", "expiration") VALUES
('laravel-cache-narsil.tables:pages', 'TzoyOToiSWxsdW1pbmF0ZVxTdXBwb3J0XENvbGxlY3Rpb24iOjI6e3M6ODoiACoAaXRlbXMiO2E6MTQ6e3M6NDoidXVpZCI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo0OiJ1dWlkIjtzOjQ6InR5cGUiO3M6NDoidXVpZCI7fXM6MjoiaWQiO086Mjk6Ik5hcnNpbFxTdXBwb3J0XERhdGFiYXNlQ29sdW1uIjoyOntzOjQ6Im5hbWUiO3M6MjoiaWQiO3M6NDoidHlwZSI7czo0OiJpbnQ4Ijt9czo0OiJzbHVnIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjQ6InNsdWciO3M6NDoidHlwZSI7czo3OiJ2YXJjaGFyIjt9czo4OiJyZXZpc2lvbiI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo4OiJyZXZpc2lvbiI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjk6InB1Ymxpc2hlZCI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo5OiJwdWJsaXNoZWQiO3M6NDoidHlwZSI7czo0OiJib29sIjt9czoxNDoicHVibGlzaGVkX2Zyb20iO086Mjk6Ik5hcnNpbFxTdXBwb3J0XERhdGFiYXNlQ29sdW1uIjoyOntzOjQ6Im5hbWUiO3M6MTQ6InB1Ymxpc2hlZF9mcm9tIjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMjoicHVibGlzaGVkX3RvIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEyOiJwdWJsaXNoZWRfdG8iO3M6NDoidHlwZSI7czo5OiJ0aW1lc3RhbXAiO31zOjEwOiJjcmVhdGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJjcmVhdGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoiY3JlYXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoiY3JlYXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjEwOiJ1cGRhdGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJ1cGRhdGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoidXBkYXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoidXBkYXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjEwOiJkZWxldGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJkZWxldGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoiZGVsZXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoiZGVsZXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjU6InRpdGxlIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjU6InRpdGxlIjtzOjQ6InR5cGUiO3M6NToianNvbmIiO319czoyODoiACoAZXNjYXBlV2hlbkNhc3RpbmdUb1N0cmluZyI7YjowO30=', 2081085633),
('laravel-cache-narsil.tables:events', 'TzoyOToiSWxsdW1pbmF0ZVxTdXBwb3J0XENvbGxlY3Rpb24iOjI6e3M6ODoiACoAaXRlbXMiO2E6MTQ6e3M6NDoidXVpZCI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo0OiJ1dWlkIjtzOjQ6InR5cGUiO3M6NDoidXVpZCI7fXM6MjoiaWQiO086Mjk6Ik5hcnNpbFxTdXBwb3J0XERhdGFiYXNlQ29sdW1uIjoyOntzOjQ6Im5hbWUiO3M6MjoiaWQiO3M6NDoidHlwZSI7czo0OiJpbnQ4Ijt9czo0OiJzbHVnIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjQ6InNsdWciO3M6NDoidHlwZSI7czo3OiJ2YXJjaGFyIjt9czo4OiJyZXZpc2lvbiI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo4OiJyZXZpc2lvbiI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjk6InB1Ymxpc2hlZCI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czo5OiJwdWJsaXNoZWQiO3M6NDoidHlwZSI7czo0OiJib29sIjt9czoxNDoicHVibGlzaGVkX2Zyb20iO086Mjk6Ik5hcnNpbFxTdXBwb3J0XERhdGFiYXNlQ29sdW1uIjoyOntzOjQ6Im5hbWUiO3M6MTQ6InB1Ymxpc2hlZF9mcm9tIjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMjoicHVibGlzaGVkX3RvIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEyOiJwdWJsaXNoZWRfdG8iO3M6NDoidHlwZSI7czo5OiJ0aW1lc3RhbXAiO31zOjEwOiJjcmVhdGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJjcmVhdGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoiY3JlYXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoiY3JlYXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjEwOiJ1cGRhdGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJ1cGRhdGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoidXBkYXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoidXBkYXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjEwOiJkZWxldGVkX2F0IjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjEwOiJkZWxldGVkX2F0IjtzOjQ6InR5cGUiO3M6OToidGltZXN0YW1wIjt9czoxMDoiZGVsZXRlZF9ieSI7TzoyOToiTmFyc2lsXFN1cHBvcnRcRGF0YWJhc2VDb2x1bW4iOjI6e3M6NDoibmFtZSI7czoxMDoiZGVsZXRlZF9ieSI7czo0OiJ0eXBlIjtzOjQ6ImludDgiO31zOjU6InRpdGxlIjtPOjI5OiJOYXJzaWxcU3VwcG9ydFxEYXRhYmFzZUNvbHVtbiI6Mjp7czo0OiJuYW1lIjtzOjU6InRpdGxlIjtzOjQ6InR5cGUiO3M6NToianNvbmIiO319czoyODoiACoAZXNjYXBlV2hlbkNhc3RpbmdUb1N0cmluZyI7YjowO30=', 2081085674);

INSERT INTO "public"."configurations" ("id", "default_language", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, NULL, '2025-12-14 15:18:12', 1, '2025-12-14 15:18:12', NULL);


INSERT INTO "public"."events" ("uuid", "id", "slug", "revision", "published", "published_from", "published_to", "created_at", "created_by", "updated_at", "updated_by", "deleted_at", "deleted_by", "title") VALUES
('019b1d70-c5e6-7045-b5d2-03b3282fe694', 4, '{"en":"quidem-corporis"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "deserunt amet eligendi"}'),
('019b1d70-c5e9-71b5-b296-7d1445f3433e', 5, '{"en":"cupiditate-magnam"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "omnis quo eum"}'),
('019b1d70-c5ed-72e1-ad86-4e0cbe52cfa3', 6, '{"en":"iusto"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "dolor fugit dolores"}'),
('019b1d70-c5f0-7007-8922-4195033cf012', 7, '{"en":"et-velit"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "et laboriosam consequuntur"}'),
('019b1d70-c5f4-736a-b3d8-c22c6c79901e', 8, '{"en":"sunt"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "aperiam doloribus blanditiis"}'),
('019b1d70-c5f6-70e7-84be-9815f3fcc461', 9, '{"en":"cum-autem"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "nihil placeat beatae"}'),
('019b1d70-c5f9-7287-b672-d5964b6ea7f9', 10, '{"en":"sint-sit"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL, NULL, NULL, '{"en": "dicta veniam et"}'),
('019b1d70-ef87-7353-983e-4c8b04307561', 1, '{"en":"nesciunt"}', 2, 'f', '2025-12-08 03:04:00', NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:19', 1, NULL, NULL, '{"en": "qui molestias quia"}'),
('019b1d70-c5d9-7055-a473-0f1812ac6779', 1, '{"en":"nesciunt"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:18:19', NULL, '2025-12-14 15:18:19', 1, '{"en": "qui molestias quia"}'),
('019b1d77-398c-7258-87e3-d4d60eadacbd', 2, '{"en":"dolorem"}', 2, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:25:11', 1, NULL, NULL, '{"en": "aspernatur illum quia"}'),
('019b1d70-c5de-70d3-8efa-161199967ae2', 2, '{"en":"quam-blanditiis"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:25:11', NULL, '2025-12-14 15:25:11', 1, '{"en": "aspernatur illum quia"}'),
('019b1d70-c5e2-7227-9d0b-00d74c0c6748', 3, '{"en":"dolorem"}', 1, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:27:25', NULL, '2025-12-14 15:27:25', 1, '{"en": "eum animi veniam"}'),
('019b1d79-6158-70ce-bbff-3d971a08d5df', 3, '{"en":"dolorem"}', 3, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:27:32', 1, NULL, NULL, '{"en": "eum animi veniam"}'),
('019b1d79-45df-72ef-89c6-bd4ea2a0340b', 3, '{"en":"dolor"}', 2, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 15:27:32', 1, '2025-12-14 15:27:32', 1, '{"en": "eum animi veniam"}');

INSERT INTO "public"."field_block" ("id", "block_id", "field_id") VALUES
(1, 2, 2),
(2, 1, 10),
(3, 3, 10),
(4, 4, 10);
INSERT INTO "public"."field_options" ("uuid", "field_id", "value", "label", "position", "created_at", "updated_at") VALUES
('019b1d70-c572-7117-aed7-1f056e5f6b3f', 6, 'h1', '{"en": "h1"}', 0, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c573-73ec-aca1-c6226424f465', 6, 'h2', '{"en": "h2"}', 1, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c574-714e-be80-4aefe025e2aa', 6, 'h3', '{"en": "h3"}', 2, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c576-7126-b4e4-1848b63d07f5', 6, 'h4', '{"en": "h4"}', 3, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c578-7172-a07d-b88ce2455c92', 6, 'h5', '{"en": "h5"}', 4, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c579-70a1-9b3d-deac0561e475', 6, 'h6', '{"en": "h6"}', 5, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c580-722c-b8b5-d01d50866b6a', 7, 'h1', '{"en": "h1"}', 0, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c581-726c-945b-e0e6c9ecf234', 7, 'h2', '{"en": "h2"}', 1, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c582-7021-ab27-a2e5d447af76', 7, 'h3', '{"en": "h3"}', 2, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c584-713e-99d1-f8531bc10549', 7, 'h4', '{"en": "h4"}', 3, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c585-7384-8023-4220106a80d0', 7, 'h5', '{"en": "h5"}', 4, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
('019b1d70-c587-73f9-ad8e-b376e08b98ed', 7, 'h6', '{"en": "h6"}', 5, '2025-12-14 15:18:08', '2025-12-14 15:18:08');

INSERT INTO "public"."fields" ("id", "handle", "type", "name", "description", "translatable", "class_name", "settings", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'title', 'Narsil\Contracts\Fields\TextField', '{"en": "Title"}', '{}', 't', NULL, '{"type": "text", "value": "", "required": true}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(2, 'accordion-builder', 'Narsil\Contracts\Fields\BuilderField', '{"en": "Items"}', '{}', 'f', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(3, 'accordion-item-trigger', 'Narsil\Contracts\Fields\TextField', '{"en": "Trigger"}', '{}', 't', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(4, 'accordion-item-content', 'Narsil\Contracts\Fields\RichTextField', '{"en": "Content"}', '{}', 't', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(5, 'headline', 'Narsil\Contracts\Fields\TextField', '{"en": "Headline"}', '{}', 't', NULL, '{"value": "", "required": true}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(6, 'headline-level', 'Narsil\Contracts\Fields\SelectField', '{"en": "Level"}', '{}', 'f', NULL, '{"value": "h1", "required": true}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(7, 'headline-style', 'Narsil\Contracts\Fields\SelectField', '{"en": "Style"}', '{}', 'f', NULL, '{"value": "h6", "required": true}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(8, 'excerpt', 'Narsil\Contracts\Fields\RichTextField', '{"en": "Excerpt"}', '{}', 'f', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(9, 'url', 'Narsil\Contracts\Fields\TextField', '{"en": "URL"}', '{}', 'f', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(10, 'content', 'Narsil\Contracts\Fields\BuilderField', '{"en": "Content"}', '{}', 'f', NULL, '{}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL);

INSERT INTO "public"."footer_social_links" ("uuid", "footer_id", "icon", "label", "url", "position", "created_at", "updated_at") VALUES
('019b1d70-7dc2-7256-a3cc-5cd279dfe4a5', 1, 'linkedin', '{"en": "LinkedIn"}', 'https://linkedin.com', 0, '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7dc7-7360-b739-eee260852858', 1, 'instagram', '{"en": "Instagram"}', 'https://instagram.com', 1, '2025-12-14 15:17:50', '2025-12-14 15:17:50');
INSERT INTO "public"."footers" ("id", "handle", "logo", "company", "address_line_1", "address_line_2", "email", "phone", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'ex-omnis-dolore-ducimus-labore', NULL, 'Mohr and Sons', '78747 Barton Crossroad', '66144 East Candelariostad', '{"en": "ottilie.stark@example.org"}', '234.736.4407', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL);

INSERT INTO "public"."host_locale_languages" ("uuid", "locale_uuid", "language", "position", "created_at", "updated_at") VALUES
('019b1d70-7de9-7158-9366-794f33f513e5', '019b1d70-7de3-70d3-8c70-bbfd1e934399', 'en', 0, '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7ded-73d9-8dbe-1ca5a72aa037', '019b1d70-7de3-70d3-8c70-bbfd1e934399', 'de', 1, '2025-12-14 15:17:50', '2025-12-14 15:17:50'),
('019b1d70-7df0-7042-9bbc-09074e1087ce', '019b1d70-7de3-70d3-8c70-bbfd1e934399', 'fr', 2, '2025-12-14 15:17:50', '2025-12-14 15:17:50');
INSERT INTO "public"."host_locales" ("uuid", "host_id", "country", "position", "pattern", "regex", "created_at", "updated_at") VALUES
('019b1d70-7de3-70d3-8c70-bbfd1e934399', 1, 'default', 0, 'https://{host}/{language}', '#^https\://(?P<host>[^/]+)/(?P<language>[a-z]{2})(?:/(?P<path>.*))?$#i', '2025-12-14 15:17:50', '2025-12-14 15:17:50');
INSERT INTO "public"."hosts" ("id", "handle", "name", "created_at", "created_by", "updated_at", "updated_by", "header_id", "footer_id") VALUES
(1, 'narsil-app.ddev.site', '{"en": "narsil-app.ddev.site"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL, NULL, 1);


INSERT INTO "public"."migrations" ("id", "migration", "batch") VALUES
(1, '2026_01_01_000101_create_user_tables', 1),
(2, '2026_01_01_000102_create_user_bookmark_tables', 1),
(3, '2026_01_01_000103_create_user_configuration_tables', 1),
(4, '2026_01_01_000201_create_cache_tables', 1),
(5, '2026_01_01_000301_create_job_tables', 1),
(6, '2026_01_01_000401_create_policy_tables', 1),
(7, '2026_01_01_000402_create_user_policy_tables', 1),
(8, '2026_01_01_000501_create_host_tables', 1),
(9, '2026_01_01_000601_create_site_tables', 1),
(10, '2026_01_01_000701_create_header_tables', 1),
(11, '2026_01_01_000801_create_footer_tables', 1),
(12, '2026_01_01_000901_add_columns_to_hosts_table', 1),
(13, '2026_01_01_001001_create_field_tables', 1),
(14, '2026_01_01_001101_create_block_tables', 1),
(15, '2026_01_01_001201_create_template_tables', 1),
(16, '2026_01_01_001301_create_entity_tables', 1),
(17, '2026_01_01_001401_create_audit_log_tables', 1),
(18, '2026_01_01_001501_create_configuration_tables', 1);
INSERT INTO "public"."page_block_fields" ("uuid", "block_uuid", "field_id", "value") VALUES
('019b1dd2-4fe3-7067-a576-50979443c9d0', '019b1dd2-4fe0-704e-ac39-36f2d750d727', 2, '{"en": null}'),
('019b1dd2-5005-733a-b663-bdcfef977642', '019b1dd2-5004-729c-a0b3-e583f588cada', 3, '{"en": "trigger 1"}'),
('019b1dd2-5023-71a1-9934-f49cd1ac615b', '019b1dd2-5004-729c-a0b3-e583f588cada', 4, '{"en": "<p>content 2</p>"}'),
('019b1dd2-5044-72cd-8925-91ef6bb0590d', '019b1dd2-5042-72de-98ca-180c7dcc0680', 3, '{"en": "trigger 2"}'),
('019b1dd2-5065-7188-a352-b593f6892490', '019b1dd2-5042-72de-98ca-180c7dcc0680', 4, '{"en": "<p>content 2</p>"}'),
('019b1e16-8e5a-71e7-82af-17b6c6b39159', '019b1e16-8e57-7385-b055-f59e6102e967', 5, '{"en": "Welcome to Narsil CMS"}'),
('019b1e16-8e6c-70ec-8d52-ca94fa491595', '019b1e16-8e57-7385-b055-f59e6102e967', 8, '{"en": "<p>Visit the admin panel to create your own content.</p>"}'),
('019b1e16-8e7e-728a-97a5-995f9d00e287', '019b1e16-8e57-7385-b055-f59e6102e967', 9, '{"en": "https://narsil-app.ddev.site/narsil/dashboard"}'),
('019b1e16-8e96-715d-afa8-55a0f64fdb93', '019b1e16-8e94-7053-b100-4dea81737c20', 2, '{"en": null}'),
('019b1e16-8ebb-7389-ab96-51d599ee8bdc', '019b1e16-8eb9-71f4-aa61-2b8fa1233162', 3, '{"en": "trigger 1 en", "fr": "trigger 1 fr"}'),
('019b1e16-8edc-715e-9f62-82b886a45ee1', '019b1e16-8eb9-71f4-aa61-2b8fa1233162', 4, '{"en": "<p>content 1 en</p>", "fr": "<p>content 1 fr</p>"}'),
('019b1e16-8eff-735f-a25e-26e545f1677a', '019b1e16-8efd-7258-8000-074b3a561fe0', 3, '{"en": "trigger 2 en", "fr": "trigger 2 fr"}'),
('019b1e16-8f1d-71e1-b883-9b0dd39da576', '019b1e16-8efd-7258-8000-074b3a561fe0', 4, '{"en": "<p>content 2 en</p>", "fr": "<p>content 2 fr</p>"}'),
('019b1e10-ebd7-7172-8105-d12ba1523520', '019b1e10-ebd4-7207-96fe-aa20fb639b76', 5, '{"en": "Welcome to Narsil CMS"}'),
('019b1e10-ebe9-72d6-81ba-11b68fb0c530', '019b1e10-ebd4-7207-96fe-aa20fb639b76', 8, '{"en": "<pre><code class=\"language-typescriptreact\">Visit the admin panel to create your own content.</code></pre><p></p>"}'),
('019b1e10-ebf9-7108-b793-9ccdb2112d30', '019b1e10-ebd4-7207-96fe-aa20fb639b76', 9, '{"en": "https://narsil-app.ddev.site/narsil/dashboard"}'),
('019b1e10-ec0f-7197-a6dc-eda71139afd4', '019b1e10-ec0d-71c6-b01a-fe41457d30c6', 2, '{"en": null}'),
('019b1e10-ec2f-7006-80d6-409541a33298', '019b1e10-ec2d-711b-a8e5-4eb41b638402', 3, '{"en": "trigger 1 en", "fr": "trigger 1 fr"}'),
('019b1e10-ec4b-7118-a5d6-feccf18a57c3', '019b1e10-ec2d-711b-a8e5-4eb41b638402', 4, '{"en": "<p>content 1 en</p>", "fr": "<p>content 1 fr</p>"}'),
('019b1e10-ec6b-70eb-b0a7-4afaf1f61301', '019b1e10-ec69-737e-a207-41aa38afce85', 3, '{"en": "trigger 2 en", "fr": "trigger 2 fr"}'),
('019b1e10-ec8c-71be-84ba-47540b27d347', '019b1e10-ec69-737e-a207-41aa38afce85', 4, '{"en": "<p>content 2 en</p>", "fr": "<p>content 2 fr</p>"}'),
('019b1df9-c684-7228-a662-aa523e110cae', '019b1df9-c681-7141-9d57-c6867ca5cfc7', 2, '{"en": null}'),
('019b1df9-c6a5-70ca-9a7b-9cab89cbf8a3', '019b1df9-c6a4-7310-86d4-f1204400269a', 3, '{"en": "trigger 1 en", "fr": "trigger 1 fr"}'),
('019b1df9-c6c3-72ad-afc4-c45afd6b011d', '019b1df9-c6a4-7310-86d4-f1204400269a', 4, '{"en": "<p>content 1 en</p>", "fr": "<p>content 1 fr</p>"}'),
('019b1df9-c6e2-73f8-a724-33207cfa0816', '019b1df9-c6e0-7380-a463-9342ea829777', 3, '{"en": "trigger 2 en", "fr": "trigger 2 fr"}'),
('019b1df9-c700-7072-8365-16263a401da7', '019b1df9-c6e0-7380-a463-9342ea829777', 4, '{"en": "<p>content 2 en</p>", "fr": "<p>content 2 fr</p>"}');
INSERT INTO "public"."page_blocks" ("uuid", "entity_uuid", "parent_uuid", "block_id", "position") VALUES
('019b1dd2-4fe0-704e-ac39-36f2d750d727', '019b1dd2-4fd8-733a-9ae3-dd021165e006', NULL, 1, 0),
('019b1dd2-5004-729c-a0b3-e583f588cada', '019b1dd2-4fd8-733a-9ae3-dd021165e006', '019b1dd2-4fe0-704e-ac39-36f2d750d727', 2, 0),
('019b1dd2-5042-72de-98ca-180c7dcc0680', '019b1dd2-4fd8-733a-9ae3-dd021165e006', '019b1dd2-4fe0-704e-ac39-36f2d750d727', 2, 1),
('019b1e10-ebd4-7207-96fe-aa20fb639b76', '019b1e10-ebcd-7143-b730-5f73a1068dff', NULL, 4, 0),
('019b1e10-ec0d-71c6-b01a-fe41457d30c6', '019b1e10-ebcd-7143-b730-5f73a1068dff', NULL, 1, 1),
('019b1e10-ec2d-711b-a8e5-4eb41b638402', '019b1e10-ebcd-7143-b730-5f73a1068dff', '019b1e10-ec0d-71c6-b01a-fe41457d30c6', 2, 0),
('019b1e10-ec69-737e-a207-41aa38afce85', '019b1e10-ebcd-7143-b730-5f73a1068dff', '019b1e10-ec0d-71c6-b01a-fe41457d30c6', 2, 1),
('019b1df9-c681-7141-9d57-c6867ca5cfc7', '019b1df9-c67a-72eb-a820-13f21013d830', NULL, 1, 0),
('019b1df9-c6a4-7310-86d4-f1204400269a', '019b1df9-c67a-72eb-a820-13f21013d830', '019b1df9-c681-7141-9d57-c6867ca5cfc7', 2, 0),
('019b1df9-c6e0-7380-a463-9342ea829777', '019b1df9-c67a-72eb-a820-13f21013d830', '019b1df9-c681-7141-9d57-c6867ca5cfc7', 2, 1),
('019b1e16-8e57-7385-b055-f59e6102e967', '019b1e16-8e50-71ed-aaa2-7f50edd46fe6', NULL, 4, 0),
('019b1e16-8e94-7053-b100-4dea81737c20', '019b1e16-8e50-71ed-aaa2-7f50edd46fe6', NULL, 1, 1),
('019b1e16-8eb9-71f4-aa61-2b8fa1233162', '019b1e16-8e50-71ed-aaa2-7f50edd46fe6', '019b1e16-8e94-7053-b100-4dea81737c20', 2, 0),
('019b1e16-8efd-7258-8000-074b3a561fe0', '019b1e16-8e50-71ed-aaa2-7f50edd46fe6', '019b1e16-8e94-7053-b100-4dea81737c20', 2, 1);
INSERT INTO "public"."pages" ("uuid", "id", "slug", "revision", "published", "published_from", "published_to", "created_at", "created_by", "updated_at", "updated_by", "deleted_at", "deleted_by", "title") VALUES
('019b1d7d-33d0-71a6-a3bc-49ee29b08a44', 2, '{"en":"test"}', 1, 'f', NULL, NULL, '2025-12-14 15:31:43', 1, '2025-12-14 15:31:43', NULL, NULL, NULL, '{"en": "test"}'),
('019b1dd2-4fd8-733a-9ae3-dd021165e006', 1, '{"en":"quasi-invento"}', 4, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 17:47:47', 1, '2025-12-14 17:47:47', 1, '{"en": "tempore nihil ut"}'),
('019b1df9-c67a-72eb-a820-13f21013d830', 1, '{"en":"quasi-invento","fr":"quasi-invento-fr"}', 5, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 18:13:04', 1, '2025-12-14 18:13:04', 1, '{"en": "tempore nihil ut"}'),
('019b1e16-8e50-71ed-aaa2-7f50edd46fe6', 1, '{"en":"quasi-invento","fr":"quasi-invento-fr"}', 7, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 18:19:13', 1, NULL, NULL, '{"en": "tempore nihil ut"}'),
('019b1e10-ebcd-7143-b730-5f73a1068dff', 1, '{"en":"quasi-invento","fr":"quasi-invento-fr"}', 6, 'f', NULL, NULL, '2025-12-14 15:18:08', 1, '2025-12-14 18:19:13', 1, '2025-12-14 18:19:13', 1, '{"en": "tempore nihil ut"}');

INSERT INTO "public"."permissions" ("id", "handle", "name", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'configurations_update', '{"en": "configurations_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(2, 'blocks_create', '{"en": "blocks_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(3, 'blocks_delete', '{"en": "blocks_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(4, 'blocks_deleteAny', '{"en": "blocks_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(5, 'blocks_update', '{"en": "blocks_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(6, 'blocks_view', '{"en": "blocks_view"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(7, 'blocks_viewAny', '{"en": "blocks_viewAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(8, 'fields_create', '{"en": "fields_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(9, 'fields_delete', '{"en": "fields_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(10, 'fields_deleteAny', '{"en": "fields_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(11, 'fields_update', '{"en": "fields_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(12, 'fields_view', '{"en": "fields_view"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(13, 'fields_viewAny', '{"en": "fields_viewAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(14, 'templates_create', '{"en": "templates_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(15, 'templates_delete', '{"en": "templates_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(16, 'templates_deleteAny', '{"en": "templates_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(17, 'templates_update', '{"en": "templates_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(18, 'templates_view', '{"en": "templates_view"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(19, 'templates_viewAny', '{"en": "templates_viewAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(20, 'entities_create', '{"en": "entities_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(21, 'entities_delete', '{"en": "entities_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(22, 'entities_deleteAny', '{"en": "entities_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(23, 'entities_update', '{"en": "entities_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(24, 'entities_view', '{"en": "entities_view"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(25, 'entities_viewAny', '{"en": "entities_viewAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(26, 'footers_create', '{"en": "footers_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(27, 'footers_delete', '{"en": "footers_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(28, 'footers_deleteAny', '{"en": "footers_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(29, 'footers_update', '{"en": "footers_update"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(30, 'footers_view', '{"en": "footers_view"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(31, 'footers_viewAny', '{"en": "footers_viewAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(32, 'headers_create', '{"en": "headers_create"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(33, 'headers_delete', '{"en": "headers_delete"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(34, 'headers_deleteAny', '{"en": "headers_deleteAny"}', '2025-12-14 15:17:49', NULL, '2025-12-14 15:17:49', NULL),
(35, 'headers_update', '{"en": "headers_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(36, 'headers_view', '{"en": "headers_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(37, 'headers_viewAny', '{"en": "headers_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(38, 'hosts_create', '{"en": "hosts_create"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(39, 'hosts_delete', '{"en": "hosts_delete"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(40, 'hosts_deleteAny', '{"en": "hosts_deleteAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(41, 'hosts_update', '{"en": "hosts_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(42, 'hosts_view', '{"en": "hosts_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(43, 'hosts_viewAny', '{"en": "hosts_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(44, 'permissions_update', '{"en": "permissions_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(45, 'permissions_view', '{"en": "permissions_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(46, 'permissions_viewAny', '{"en": "permissions_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(47, 'roles_create', '{"en": "roles_create"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(48, 'roles_delete', '{"en": "roles_delete"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(49, 'roles_deleteAny', '{"en": "roles_deleteAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(50, 'roles_update', '{"en": "roles_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(51, 'roles_view', '{"en": "roles_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(52, 'roles_viewAny', '{"en": "roles_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(53, 'sites_update', '{"en": "sites_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(54, 'sites_view', '{"en": "sites_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(55, 'sites_viewAny', '{"en": "sites_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(56, 'site_pages_create', '{"en": "site_pages_create"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(57, 'site_pages_delete', '{"en": "site_pages_delete"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(58, 'site_pages_deleteAny', '{"en": "site_pages_deleteAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(59, 'site_pages_update', '{"en": "site_pages_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(60, 'site_pages_view', '{"en": "site_pages_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(61, 'site_pages_viewAny', '{"en": "site_pages_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(62, 'users_create', '{"en": "users_create"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(63, 'users_delete', '{"en": "users_delete"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(64, 'users_deleteAny', '{"en": "users_deleteAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(65, 'users_update', '{"en": "users_update"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(66, 'users_view', '{"en": "users_view"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(67, 'users_viewAny', '{"en": "users_viewAny"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL),
(68, 'events_view', '{"en": "events_view"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(69, 'events_create', '{"en": "events_create"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(70, 'events_update', '{"en": "events_update"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(71, 'events_delete', '{"en": "events_delete"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(72, 'pages_view', '{"en": "pages_view"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(73, 'pages_create', '{"en": "pages_create"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(74, 'pages_update', '{"en": "pages_update"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(75, 'pages_delete', '{"en": "pages_delete"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL);


INSERT INTO "public"."roles" ("id", "handle", "name", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'super_admin', '{"en": "Super Admin"}', '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL);
INSERT INTO "public"."sessions" ("id", "user_id", "ip_address", "user_agent", "payload", "last_activity") VALUES
('273Q2mk8jwWK6XlGXIA2pYUjg1rlQzir7KVr6dyA', 1, '172.18.0.6', 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/143.0.0.0 Safari/537.36', 'YToxMDp7czo2OiJfdG9rZW4iO3M6NDA6Im9obmJxREkyQTFwS0EyeUtRZ3NqOFB5UnE5Z1hRcG9xNVcyRnhnRGsiO3M6OToiX3ByZXZpb3VzIjthOjI6e3M6MzoidXJsIjtzOjQ1OiJodHRwczovL25hcnNpbC1hcHAuZGRldi5zaXRlL25hcnNpbC9kYXNoYm9hcmQiO3M6NToicm91dGUiO3M6OToiZGFzaGJvYXJkIjt9czo2OiJfZmxhc2giO2E6Mjp7czozOiJvbGQiO2E6MDp7fXM6MzoibmV3IjthOjA6e319czozOiJ1cmwiO2E6MDp7fXM6NTA6ImxvZ2luX3dlYl81OWJhMzZhZGRjMmIyZjk0MDE1ODBmMDE0YzdmNThlYTRlMzA5ODlkIjtpOjE7czo1OiJjb2xvciI7czo0OiJncmF5IjtzOjg6Imxhbmd1YWdlIjtzOjI6ImVuIjtzOjY6InJhZGl1cyI7czo0OiIwLjI1IjtzOjU6InRoZW1lIjtzOjY6InN5c3RlbSI7czo3OiJjb3VudHJ5IjtzOjc6ImRlZmF1bHQiO30=', 1765736362);

INSERT INTO "public"."site_page_relations" ("id", "page_id", "target_table", "target_id", "created_at", "updated_at") VALUES
(1, 1, 'pages', 1, NULL, NULL);
INSERT INTO "public"."site_pages" ("id", "site_id", "country", "parent_id", "left_id", "right_id", "title", "slug", "content", "meta_description", "open_graph_type", "open_graph_title", "open_graph_description", "open_graph_image", "robots", "change_freq", "priority", "created_at", "updated_at") VALUES
(1, 1, 'default', NULL, NULL, NULL, '{"en": "Root"}', '{"en": "root"}', '{"en": ["pages-1"]}', NULL, 'website', NULL, NULL, NULL, 'index, follow', 'never', 1.00, '2025-12-14 15:17:50', '2025-12-14 18:10:25');
INSERT INTO "public"."site_urls" ("uuid", "host_locale_language_uuid", "page_id", "url", "created_at", "updated_at") VALUES
('d156d87a-0c2d-4782-b123-c729fbf3a84a', '019b1d70-7de9-7158-9366-794f33f513e5', 1, 'https://narsil-app.ddev.site/en', '2025-12-14 18:10:27', '2025-12-14 18:10:27'),
('1443a2df-32d8-4487-a972-95163e1679f7', '019b1d70-7ded-73d9-8dbe-1ca5a72aa037', 1, 'https://narsil-app.ddev.site/de', '2025-12-14 18:10:27', '2025-12-14 18:10:27'),
('6c8dec46-3c34-4cdd-8b89-800bf832a66d', '019b1d70-7df0-7042-9bbc-09074e1087ce', 1, 'https://narsil-app.ddev.site/fr', '2025-12-14 18:10:27', '2025-12-14 18:10:27');
INSERT INTO "public"."template_section_element" ("id", "template_section_id", "element_type", "element_id", "handle", "name", "description", "position", "width") VALUES
(1, 1, 'Narsil\Models\Elements\Field', 1, 'title', '{"en": "Title"}', '{}', 0, 100),
(2, 2, 'Narsil\Models\Elements\Field', 1, 'title', '{"en": "Title"}', '{}', 0, 100),
(3, 3, 'Narsil\Models\Elements\Field', 10, 'content', '{"en": "Content"}', '{}', 0, 100);
INSERT INTO "public"."template_sections" ("id", "template_id", "handle", "name", "position", "created_at", "updated_at") VALUES
(1, 1, 'main', '{"en": "Main"}', 0, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
(2, 2, 'main', '{"en": "Main"}', 0, '2025-12-14 15:18:08', '2025-12-14 15:18:08'),
(3, 2, 'content', '{"en": "Content"}', 0, '2025-12-14 15:18:08', '2025-12-14 15:18:08');
INSERT INTO "public"."templates" ("id", "handle", "name", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'events', '{"en": "Events"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL),
(2, 'pages', '{"en": "Pages"}', '2025-12-14 15:18:08', 1, '2025-12-14 15:18:08', NULL);

INSERT INTO "public"."user_configurations" ("user_id", "language", "color", "radius", "theme", "preferences", "created_at", "updated_at") VALUES
(1, 'en', 'gray', 0.25, 'system', NULL, '2025-12-14 15:17:50', '2025-12-14 15:17:50');

INSERT INTO "public"."user_role" ("id", "user_id", "role_id") VALUES
(1, 1, 1);
INSERT INTO "public"."users" ("id", "enabled", "last_name", "first_name", "email", "email_verified_at", "password", "two_factor_secret", "two_factor_recovery_codes", "two_factor_confirmed_at", "remember_token", "avatar", "created_at", "created_by", "updated_at", "updated_by") VALUES
(1, 'f', 'Super', 'Admin', 'admin@narsil.io', '2025-12-14 15:17:50', '$2y$12$TCF/BgdOwyVAc3yDzYPfOOnq55k/2M24TijHpUpxHtmYaud9j35ny', NULL, NULL, NULL, NULL, NULL, '2025-12-14 15:17:50', NULL, '2025-12-14 15:17:50', NULL);
