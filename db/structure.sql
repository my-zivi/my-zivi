SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pg_trgm; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_trgm WITH SCHEMA public;


--
-- Name: EXTENSION pg_trgm; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_trgm IS 'text similarity measurement and index searching based on trigrams';


--
-- Name: civil_servant_agreed_changed(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.civil_servant_agreed_changed() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
    BEGIN
        UPDATE services
        SET civil_servant_decided_at = NOW()
        WHERE id = NEW.id;
        RETURN NULL;
    END;
$$;


--
-- Name: organization_agreed_changed(); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION public.organization_agreed_changed() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    UPDATE services SET organization_decided_at = NOW()
      WHERE id = NEW.id;
    RETURN NULL;
  END;
$$;


SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: action_text_rich_texts; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.action_text_rich_texts (
    id bigint NOT NULL,
    name character varying NOT NULL,
    body text,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.action_text_rich_texts_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: action_text_rich_texts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.action_text_rich_texts_id_seq OWNED BY public.action_text_rich_texts.id;


--
-- Name: active_storage_attachments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_attachments (
    id bigint NOT NULL,
    name character varying NOT NULL,
    record_type character varying NOT NULL,
    record_id bigint NOT NULL,
    blob_id bigint NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_attachments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_attachments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_attachments_id_seq OWNED BY public.active_storage_attachments.id;


--
-- Name: active_storage_blobs; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.active_storage_blobs (
    id bigint NOT NULL,
    key character varying NOT NULL,
    filename character varying NOT NULL,
    content_type character varying,
    metadata text,
    byte_size bigint NOT NULL,
    checksum character varying NOT NULL,
    created_at timestamp without time zone NOT NULL
);


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.active_storage_blobs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: active_storage_blobs_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.active_storage_blobs_id_seq OWNED BY public.active_storage_blobs.id;


--
-- Name: addresses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.addresses (
    id bigint NOT NULL,
    primary_line character varying NOT NULL,
    secondary_line character varying,
    street character varying NOT NULL,
    supplement character varying,
    city character varying NOT NULL,
    zip integer NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: addresses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.addresses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: addresses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.addresses_id_seq OWNED BY public.addresses.id;


--
-- Name: ar_internal_metadata; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.ar_internal_metadata (
    key character varying NOT NULL,
    value character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blog_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_entries (
    id bigint NOT NULL,
    title character varying NOT NULL,
    body text NOT NULL,
    author character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blog_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_entries_id_seq OWNED BY public.blog_entries.id;


--
-- Name: blog_entries; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.blog_entries (
    id bigint NOT NULL,
    title character varying NOT NULL,
    author character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: blog_entries_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.blog_entries_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: blog_entries_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.blog_entries_id_seq OWNED BY public.blog_entries.id;


--
-- Name: civil_servants; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.civil_servants (
    id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    zdp integer,
    hometown character varying,
    birthday date,
    phone character varying,
    iban character varying,
    health_insurance character varying,
    address_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    regional_center character varying,
    registration_step character varying
);


--
-- Name: civil_servants_driving_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.civil_servants_driving_licenses (
    civil_servant_id bigint NOT NULL,
    driving_license_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: civil_servants_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.civil_servants_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: civil_servants_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.civil_servants_id_seq OWNED BY public.civil_servants.id;


--
-- Name: civil_servants_workshops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.civil_servants_workshops (
    civil_servant_id bigint NOT NULL,
    workshop_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: creditor_details; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.creditor_details (
    id bigint NOT NULL,
    bic character varying,
    iban character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: creditor_details_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.creditor_details_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: creditor_details_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.creditor_details_id_seq OWNED BY public.creditor_details.id;


--
-- Name: driving_licenses; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.driving_licenses (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: driving_licenses_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.driving_licenses_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: driving_licenses_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.driving_licenses_id_seq OWNED BY public.driving_licenses.id;


--
-- Name: driving_licenses_service_specifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.driving_licenses_service_specifications (
    driving_license_id bigint NOT NULL,
    service_specification_id bigint NOT NULL,
    mandatory boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: expense_sheets; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.expense_sheets (
    id bigint NOT NULL,
    beginning date NOT NULL,
    ending date NOT NULL,
    work_days integer NOT NULL,
    unpaid_company_holiday_days integer DEFAULT 0 NOT NULL,
    paid_company_holiday_days integer DEFAULT 0 NOT NULL,
    company_holiday_comment character varying,
    workfree_days integer DEFAULT 0 NOT NULL,
    sick_days integer DEFAULT 0 NOT NULL,
    sick_comment character varying,
    paid_vacation_days integer DEFAULT 0 NOT NULL,
    paid_vacation_comment character varying,
    unpaid_vacation_days integer DEFAULT 0 NOT NULL,
    unpaid_vacation_comment character varying,
    driving_expenses numeric(8,2) DEFAULT 0 NOT NULL,
    driving_expenses_comment character varying,
    extraordinary_expenses numeric(8,2) DEFAULT 0 NOT NULL,
    extraordinary_expenses_comment character varying,
    clothing_expenses numeric(8,2) DEFAULT 0 NOT NULL,
    clothing_expenses_comment character varying,
    credited_iban character varying,
    state integer DEFAULT 0 NOT NULL,
    amount numeric(8,2) DEFAULT 0 NOT NULL,
    service_id bigint NOT NULL,
    payment_id bigint,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: expense_sheets_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.expense_sheets_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: expense_sheets_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.expense_sheets_id_seq OWNED BY public.expense_sheets.id;


--
-- Name: job_postings; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.job_postings (
    id bigint NOT NULL,
    title character varying,
    link character varying,
    description text,
    publication_date date,
    icon_url character varying,
    company character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: job_postings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.job_postings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: job_postings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.job_postings_id_seq OWNED BY public.job_postings.id;


--
-- Name: mailing_lists; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.mailing_lists (
    id bigint NOT NULL,
    email character varying NOT NULL,
    name character varying NOT NULL,
    telephone character varying NOT NULL,
    organization character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: mailing_lists_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.mailing_lists_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mailing_lists_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.mailing_lists_id_seq OWNED BY public.mailing_lists.id;


--
-- Name: organization_holidays; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_holidays (
    id bigint NOT NULL,
    beginning date NOT NULL,
    ending date NOT NULL,
    description character varying NOT NULL,
    organization_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organization_holidays_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_holidays_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_holidays_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_holidays_id_seq OWNED BY public.organization_holidays.id;


--
-- Name: organization_members; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organization_members (
    id bigint NOT NULL,
    organization_id bigint NOT NULL,
    first_name character varying NOT NULL,
    last_name character varying NOT NULL,
    phone character varying NOT NULL,
    organization_role character varying NOT NULL,
    contact_email character varying,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organization_members_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organization_members_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organization_members_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organization_members_id_seq OWNED BY public.organization_members.id;


--
-- Name: organizations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.organizations (
    id bigint NOT NULL,
    name character varying NOT NULL,
    intro_text text,
    address_id bigint NOT NULL,
    letter_address_id bigint,
    creditor_detail_id bigint,
    identification_number character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: organizations_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.organizations_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: organizations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.organizations_id_seq OWNED BY public.organizations.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.payments (
    id bigint NOT NULL,
    paid_timestamp timestamp without time zone,
    organization_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    amount integer DEFAULT 0 NOT NULL,
    state integer DEFAULT 0 NOT NULL,
    expense_sheets_count integer
);


--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.payments_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.schema_migrations (
    version character varying NOT NULL
);


--
-- Name: service_specifications; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_specifications (
    id bigint NOT NULL,
    name character varying NOT NULL,
    internal_note character varying,
    work_clothing_expenses numeric(8,2) NOT NULL,
    accommodation_expenses numeric(8,2) NOT NULL,
    work_days_expenses jsonb NOT NULL,
    paid_vacation_expenses jsonb NOT NULL,
    first_day_expenses jsonb NOT NULL,
    last_day_expenses jsonb NOT NULL,
    location character varying,
    active boolean DEFAULT true,
    identification_number character varying NOT NULL,
    organization_id bigint NOT NULL,
    contact_person_id bigint NOT NULL,
    lead_person_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: service_specifications_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.service_specifications_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: service_specifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.service_specifications_id_seq OWNED BY public.service_specifications.id;


--
-- Name: service_specifications_workshops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.service_specifications_workshops (
    workshop_id bigint NOT NULL,
    service_specification_id bigint NOT NULL,
    mandatory boolean DEFAULT true NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: services; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.services (
    id bigint NOT NULL,
    beginning date NOT NULL,
    ending date NOT NULL,
    confirmation_date date,
    service_type integer DEFAULT 0 NOT NULL,
    last_service boolean DEFAULT false NOT NULL,
    feedback_mail_sent boolean DEFAULT false NOT NULL,
    civil_servant_id bigint NOT NULL,
    service_specification_id bigint NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    civil_servant_agreed boolean,
    civil_servant_decided_at timestamp without time zone,
    organization_agreed boolean,
    organization_decided_at timestamp without time zone
);


--
-- Name: services_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.services_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: services_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.services_id_seq OWNED BY public.services.id;


--
-- Name: sys_admins; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.sys_admins (
    id bigint NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: sys_admins_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.sys_admins_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sys_admins_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.sys_admins_id_seq OWNED BY public.sys_admins.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.users (
    id bigint NOT NULL,
    email character varying NOT NULL,
    referencee_id bigint,
    referencee_type character varying,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip inet,
    last_sign_in_ip inet,
    confirmation_token character varying,
    confirmed_at timestamp without time zone,
    confirmation_sent_at timestamp without time zone,
    unconfirmed_email character varying,
    failed_attempts integer DEFAULT 0 NOT NULL,
    unlock_token character varying,
    locked_at timestamp without time zone,
    language character varying DEFAULT 'de'::character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL,
    invitation_token character varying,
    invitation_created_at timestamp without time zone,
    invitation_sent_at timestamp without time zone,
    invitation_accepted_at timestamp without time zone,
    invitation_limit integer,
    invited_by_type character varying,
    invited_by_id bigint,
    invitations_count integer DEFAULT 0
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: workshops; Type: TABLE; Schema: public; Owner: -
--

CREATE TABLE public.workshops (
    id bigint NOT NULL,
    name character varying NOT NULL,
    created_at timestamp(6) without time zone NOT NULL,
    updated_at timestamp(6) without time zone NOT NULL
);


--
-- Name: workshops_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE public.workshops_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: workshops_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE public.workshops_id_seq OWNED BY public.workshops.id;


--
-- Name: action_text_rich_texts id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts ALTER COLUMN id SET DEFAULT nextval('public.action_text_rich_texts_id_seq'::regclass);


--
-- Name: active_storage_attachments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments ALTER COLUMN id SET DEFAULT nextval('public.active_storage_attachments_id_seq'::regclass);


--
-- Name: active_storage_blobs id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs ALTER COLUMN id SET DEFAULT nextval('public.active_storage_blobs_id_seq'::regclass);


--
-- Name: addresses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses ALTER COLUMN id SET DEFAULT nextval('public.addresses_id_seq'::regclass);


--
-- Name: blog_entries id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_entries ALTER COLUMN id SET DEFAULT nextval('public.blog_entries_id_seq'::regclass);


--
-- Name: civil_servants id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants ALTER COLUMN id SET DEFAULT nextval('public.civil_servants_id_seq'::regclass);


--
-- Name: creditor_details id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_details ALTER COLUMN id SET DEFAULT nextval('public.creditor_details_id_seq'::regclass);


--
-- Name: driving_licenses id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driving_licenses ALTER COLUMN id SET DEFAULT nextval('public.driving_licenses_id_seq'::regclass);


--
-- Name: expense_sheets id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sheets ALTER COLUMN id SET DEFAULT nextval('public.expense_sheets_id_seq'::regclass);


--
-- Name: job_postings id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_postings ALTER COLUMN id SET DEFAULT nextval('public.job_postings_id_seq'::regclass);


--
-- Name: mailing_lists id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailing_lists ALTER COLUMN id SET DEFAULT nextval('public.mailing_lists_id_seq'::regclass);


--
-- Name: organization_holidays id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_holidays ALTER COLUMN id SET DEFAULT nextval('public.organization_holidays_id_seq'::regclass);


--
-- Name: organization_members id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_members ALTER COLUMN id SET DEFAULT nextval('public.organization_members_id_seq'::regclass);


--
-- Name: organizations id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations ALTER COLUMN id SET DEFAULT nextval('public.organizations_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: service_specifications id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications ALTER COLUMN id SET DEFAULT nextval('public.service_specifications_id_seq'::regclass);


--
-- Name: services id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services ALTER COLUMN id SET DEFAULT nextval('public.services_id_seq'::regclass);


--
-- Name: sys_admins id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_admins ALTER COLUMN id SET DEFAULT nextval('public.sys_admins_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Name: workshops id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops ALTER COLUMN id SET DEFAULT nextval('public.workshops_id_seq'::regclass);


--
-- Name: action_text_rich_texts action_text_rich_texts_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.action_text_rich_texts
    ADD CONSTRAINT action_text_rich_texts_pkey PRIMARY KEY (id);


--
-- Name: active_storage_attachments active_storage_attachments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT active_storage_attachments_pkey PRIMARY KEY (id);


--
-- Name: active_storage_blobs active_storage_blobs_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_blobs
    ADD CONSTRAINT active_storage_blobs_pkey PRIMARY KEY (id);


--
-- Name: addresses addresses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.addresses
    ADD CONSTRAINT addresses_pkey PRIMARY KEY (id);


--
-- Name: ar_internal_metadata ar_internal_metadata_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.ar_internal_metadata
    ADD CONSTRAINT ar_internal_metadata_pkey PRIMARY KEY (key);


--
-- Name: blog_entries blog_entries_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.blog_entries
    ADD CONSTRAINT blog_entries_pkey PRIMARY KEY (id);


--
-- Name: civil_servants civil_servants_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants
    ADD CONSTRAINT civil_servants_pkey PRIMARY KEY (id);


--
-- Name: creditor_details creditor_details_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.creditor_details
    ADD CONSTRAINT creditor_details_pkey PRIMARY KEY (id);


--
-- Name: driving_licenses driving_licenses_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driving_licenses
    ADD CONSTRAINT driving_licenses_pkey PRIMARY KEY (id);


--
-- Name: expense_sheets expense_sheets_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sheets
    ADD CONSTRAINT expense_sheets_pkey PRIMARY KEY (id);


--
-- Name: job_postings job_postings_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.job_postings
    ADD CONSTRAINT job_postings_pkey PRIMARY KEY (id);


--
-- Name: mailing_lists mailing_lists_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.mailing_lists
    ADD CONSTRAINT mailing_lists_pkey PRIMARY KEY (id);


--
-- Name: organization_holidays organization_holidays_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_holidays
    ADD CONSTRAINT organization_holidays_pkey PRIMARY KEY (id);


--
-- Name: organization_members organization_members_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT organization_members_pkey PRIMARY KEY (id);


--
-- Name: organizations organizations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT organizations_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: service_specifications service_specifications_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications
    ADD CONSTRAINT service_specifications_pkey PRIMARY KEY (id);


--
-- Name: services services_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT services_pkey PRIMARY KEY (id);


--
-- Name: sys_admins sys_admins_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.sys_admins
    ADD CONSTRAINT sys_admins_pkey PRIMARY KEY (id);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: workshops workshops_pkey; Type: CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.workshops
    ADD CONSTRAINT workshops_pkey PRIMARY KEY (id);


--
-- Name: index_action_text_rich_texts_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_action_text_rich_texts_uniqueness ON public.action_text_rich_texts USING btree (record_type, record_id, name);


--
-- Name: index_active_storage_attachments_on_blob_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_active_storage_attachments_on_blob_id ON public.active_storage_attachments USING btree (blob_id);


--
-- Name: index_active_storage_attachments_uniqueness; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_attachments_uniqueness ON public.active_storage_attachments USING btree (record_type, record_id, name, blob_id);


--
-- Name: index_active_storage_blobs_on_key; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_active_storage_blobs_on_key ON public.active_storage_blobs USING btree (key);


--
-- Name: index_civil_servants_driving_licenses_on_civil_servant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_civil_servants_driving_licenses_on_civil_servant_id ON public.civil_servants_driving_licenses USING btree (civil_servant_id);


--
-- Name: index_civil_servants_driving_licenses_on_driving_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_civil_servants_driving_licenses_on_driving_license_id ON public.civil_servants_driving_licenses USING btree (driving_license_id);


--
-- Name: index_civil_servants_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_civil_servants_on_address_id ON public.civil_servants USING btree (address_id);


--
-- Name: index_civil_servants_on_zdp; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_civil_servants_on_zdp ON public.civil_servants USING btree (zdp);


--
-- Name: index_civil_servants_workshops_on_civil_servant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_civil_servants_workshops_on_civil_servant_id ON public.civil_servants_workshops USING btree (civil_servant_id);


--
-- Name: index_civil_servants_workshops_on_workshop_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_civil_servants_workshops_on_workshop_id ON public.civil_servants_workshops USING btree (workshop_id);


--
-- Name: index_driving_licenses_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_driving_licenses_on_name ON public.driving_licenses USING btree (name);


--
-- Name: index_driving_licenses_service_spec_on_driving_license_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_driving_licenses_service_spec_on_driving_license_id ON public.driving_licenses_service_specifications USING btree (driving_license_id);


--
-- Name: index_driving_licenses_service_spec_on_service_specification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_driving_licenses_service_spec_on_service_specification_id ON public.driving_licenses_service_specifications USING btree (service_specification_id);


--
-- Name: index_expense_sheets_on_payment_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_expense_sheets_on_payment_id ON public.expense_sheets USING btree (payment_id);


--
-- Name: index_expense_sheets_on_service_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_expense_sheets_on_service_id ON public.expense_sheets USING btree (service_id);


--
-- Name: index_job_postings_on_link; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_job_postings_on_link ON public.job_postings USING btree (link);


--
-- Name: index_mailing_lists_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_mailing_lists_on_email ON public.mailing_lists USING btree (email);


--
-- Name: index_organization_holidays_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_holidays_on_organization_id ON public.organization_holidays USING btree (organization_id);


--
-- Name: index_organization_members_on_contact_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_organization_members_on_contact_email ON public.organization_members USING btree (contact_email);


--
-- Name: index_organization_members_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organization_members_on_organization_id ON public.organization_members USING btree (organization_id);


--
-- Name: index_organizations_on_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_address_id ON public.organizations USING btree (address_id);


--
-- Name: index_organizations_on_creditor_detail_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_creditor_detail_id ON public.organizations USING btree (creditor_detail_id);


--
-- Name: index_organizations_on_letter_address_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_organizations_on_letter_address_id ON public.organizations USING btree (letter_address_id);


--
-- Name: index_payments_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_payments_on_organization_id ON public.payments USING btree (organization_id);


--
-- Name: index_service_spec_workshops_on_service_spec_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_spec_workshops_on_service_spec_id ON public.service_specifications_workshops USING btree (service_specification_id);


--
-- Name: index_service_spec_workshops_on_service_specification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_spec_workshops_on_service_specification_id ON public.service_specifications_workshops USING btree (workshop_id);


--
-- Name: index_service_specifications_on_contact_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_specifications_on_contact_person_id ON public.service_specifications USING btree (contact_person_id);


--
-- Name: index_service_specifications_on_identification_number; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_service_specifications_on_identification_number ON public.service_specifications USING btree (identification_number);


--
-- Name: index_service_specifications_on_lead_person_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_specifications_on_lead_person_id ON public.service_specifications USING btree (lead_person_id);


--
-- Name: index_service_specifications_on_organization_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_service_specifications_on_organization_id ON public.service_specifications USING btree (organization_id);


--
-- Name: index_services_on_civil_servant_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_civil_servant_id ON public.services USING btree (civil_servant_id);


--
-- Name: index_services_on_service_specification_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_services_on_service_specification_id ON public.services USING btree (service_specification_id);


--
-- Name: index_sys_admins_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sys_admins_on_email ON public.sys_admins USING btree (email);


--
-- Name: index_sys_admins_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sys_admins_on_reset_password_token ON public.sys_admins USING btree (reset_password_token);


--
-- Name: index_sys_admins_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_sys_admins_on_unlock_token ON public.sys_admins USING btree (unlock_token);


--
-- Name: index_users_on_confirmation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_confirmation_token ON public.users USING btree (confirmation_token);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_email ON public.users USING btree (email);


--
-- Name: index_users_on_invitation_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_invitation_token ON public.users USING btree (invitation_token);


--
-- Name: index_users_on_invitations_count; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invitations_count ON public.users USING btree (invitations_count);


--
-- Name: index_users_on_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invited_by_id ON public.users USING btree (invited_by_id);


--
-- Name: index_users_on_invited_by_type_and_invited_by_id; Type: INDEX; Schema: public; Owner: -
--

CREATE INDEX index_users_on_invited_by_type_and_invited_by_id ON public.users USING btree (invited_by_type, invited_by_id);


--
-- Name: index_users_on_referencee_id_and_referencee_type; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_referencee_id_and_referencee_type ON public.users USING btree (referencee_id, referencee_type);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON public.users USING btree (reset_password_token);


--
-- Name: index_users_on_unlock_token; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_users_on_unlock_token ON public.users USING btree (unlock_token);


--
-- Name: index_workshops_on_name; Type: INDEX; Schema: public; Owner: -
--

CREATE UNIQUE INDEX index_workshops_on_name ON public.workshops USING btree (name);


--
-- Name: services civil_servant_agreed_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER civil_servant_agreed_insert_trigger AFTER INSERT ON public.services FOR EACH ROW WHEN ((new.civil_servant_agreed IS NOT NULL)) EXECUTE FUNCTION public.civil_servant_agreed_changed();


--
-- Name: services civil_servant_agreed_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER civil_servant_agreed_update_trigger AFTER UPDATE ON public.services FOR EACH ROW WHEN ((old.civil_servant_agreed IS DISTINCT FROM new.civil_servant_agreed)) EXECUTE FUNCTION public.civil_servant_agreed_changed();


--
-- Name: services organization_agreed_insert_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER organization_agreed_insert_trigger AFTER INSERT ON public.services FOR EACH ROW WHEN ((new.organization_agreed IS NOT NULL)) EXECUTE FUNCTION public.organization_agreed_changed();


--
-- Name: services organization_agreed_update_trigger; Type: TRIGGER; Schema: public; Owner: -
--

CREATE TRIGGER organization_agreed_update_trigger AFTER UPDATE ON public.services FOR EACH ROW WHEN ((old.organization_agreed IS DISTINCT FROM new.organization_agreed)) EXECUTE FUNCTION public.organization_agreed_changed();


--
-- Name: services fk_rails_05245f4b1b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_rails_05245f4b1b FOREIGN KEY (service_specification_id) REFERENCES public.service_specifications(id);


--
-- Name: services fk_rails_085da598bb; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.services
    ADD CONSTRAINT fk_rails_085da598bb FOREIGN KEY (civil_servant_id) REFERENCES public.civil_servants(id);


--
-- Name: driving_licenses_service_specifications fk_rails_09e79aa00d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driving_licenses_service_specifications
    ADD CONSTRAINT fk_rails_09e79aa00d FOREIGN KEY (driving_license_id) REFERENCES public.driving_licenses(id);


--
-- Name: driving_licenses_service_specifications fk_rails_13305e59f4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.driving_licenses_service_specifications
    ADD CONSTRAINT fk_rails_13305e59f4 FOREIGN KEY (service_specification_id) REFERENCES public.service_specifications(id);


--
-- Name: service_specifications fk_rails_26a9cc4c2c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications
    ADD CONSTRAINT fk_rails_26a9cc4c2c FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: service_specifications fk_rails_27451e0943; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications
    ADD CONSTRAINT fk_rails_27451e0943 FOREIGN KEY (contact_person_id) REFERENCES public.organization_members(id);


--
-- Name: civil_servants fk_rails_2b960c400e; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants
    ADD CONSTRAINT fk_rails_2b960c400e FOREIGN KEY (address_id) REFERENCES public.addresses(id);


--
-- Name: organization_holidays fk_rails_2bb962abb7; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_holidays
    ADD CONSTRAINT fk_rails_2bb962abb7 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: service_specifications_workshops fk_rails_2f9bdb50f1; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications_workshops
    ADD CONSTRAINT fk_rails_2f9bdb50f1 FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: payments fk_rails_3ab959bfc4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT fk_rails_3ab959bfc4 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: expense_sheets fk_rails_3be4243b19; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sheets
    ADD CONSTRAINT fk_rails_3be4243b19 FOREIGN KEY (payment_id) REFERENCES public.payments(id);


--
-- Name: civil_servants_driving_licenses fk_rails_6cacc82ee0; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants_driving_licenses
    ADD CONSTRAINT fk_rails_6cacc82ee0 FOREIGN KEY (civil_servant_id) REFERENCES public.civil_servants(id);


--
-- Name: civil_servants_workshops fk_rails_7468640641; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants_workshops
    ADD CONSTRAINT fk_rails_7468640641 FOREIGN KEY (workshop_id) REFERENCES public.workshops(id);


--
-- Name: expense_sheets fk_rails_7537bb3f83; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.expense_sheets
    ADD CONSTRAINT fk_rails_7537bb3f83 FOREIGN KEY (service_id) REFERENCES public.services(id);


--
-- Name: organizations fk_rails_8569a4d633; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organizations
    ADD CONSTRAINT fk_rails_8569a4d633 FOREIGN KEY (creditor_detail_id) REFERENCES public.creditor_details(id);


--
-- Name: service_specifications fk_rails_a76f6f7cb3; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications
    ADD CONSTRAINT fk_rails_a76f6f7cb3 FOREIGN KEY (lead_person_id) REFERENCES public.organization_members(id);


--
-- Name: civil_servants_workshops fk_rails_b91873db01; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants_workshops
    ADD CONSTRAINT fk_rails_b91873db01 FOREIGN KEY (civil_servant_id) REFERENCES public.civil_servants(id);


--
-- Name: active_storage_attachments fk_rails_c3b3935057; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.active_storage_attachments
    ADD CONSTRAINT fk_rails_c3b3935057 FOREIGN KEY (blob_id) REFERENCES public.active_storage_blobs(id);


--
-- Name: organization_members fk_rails_dd7f017308; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.organization_members
    ADD CONSTRAINT fk_rails_dd7f017308 FOREIGN KEY (organization_id) REFERENCES public.organizations(id);


--
-- Name: service_specifications_workshops fk_rails_e4c4d43970; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.service_specifications_workshops
    ADD CONSTRAINT fk_rails_e4c4d43970 FOREIGN KEY (service_specification_id) REFERENCES public.service_specifications(id);


--
-- Name: civil_servants_driving_licenses fk_rails_f0b9fba0dd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY public.civil_servants_driving_licenses
    ADD CONSTRAINT fk_rails_f0b9fba0dd FOREIGN KEY (driving_license_id) REFERENCES public.driving_licenses(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user", public;

INSERT INTO "schema_migrations" (version) VALUES
('20200611110653'),
('20200625081749'),
('20200625093448'),
('20200703212709'),
('20200709150256'),
('20200710141431'),
('20200710141949'),
('20200716070611'),
('20200723211725'),
('20200730123718'),
('20200825114315'),
('20200825211419'),
('20200915163416'),
('20201011163555'),
('20201014182656'),
('20201014183656'),
('20201014185831'),
('20201024145705'),
('20201117161845'),
('20201122111941'),
('20201123144121'),
('20201204215926'),
('20210131114416'),
('20210413115424'),
('20210413210828'),
('20210413210829'),
('20210414175455');


