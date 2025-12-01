CREATE TABLE table_parts (
	spir_project_id int NOT NULL,
	spir_machine_id int NULL,
	spir_group_id int NULL,
	asset_number varchar(30) COLLATE Latin1_General_CI_AS NOT NULL,
	material_code varchar(40) COLLATE Latin1_General_CI_AS NULL,
	[position] varchar(150) COLLATE Latin1_General_CI_AS NULL,
	material varchar(150) COLLATE Latin1_General_CI_AS NULL,
	supplier_name varchar(4000) COLLATE Latin1_General_CI_AS NULL,
	manufacturer varchar(4000) COLLATE Latin1_General_CI_AS NULL,
	manufacturer_serial_number varchar(4000) COLLATE Latin1_General_CI_AS NULL,
	created_by varchar(20) COLLATE Latin1_General_CI_AS NULL,
	creation_date smalldatetime NULL,
	updated_by varchar(20) COLLATE Latin1_General_CI_AS NULL,
	update_date smalldatetime NULL,
	maintenance_code varchar(150) COLLATE Latin1_General_CI_AS NULL,
	mark nvarchar(1) COLLATE Latin1_General_CI_AS NULL,
	tag numeric(20,2) NULL,
	revision int NULL,
	CONSTRAINT inspire_parts_pk PRIMARY KEY (spir_project_id,asset_number),
);

CREATE TABLE table_refresh_data (
	spir_project_id int NOT NULL,
	material_code varchar(40) COLLATE Latin1_General_CI_AS NOT NULL,
	maintenance_code varchar(150) COLLATE Latin1_General_CI_AS NULL,
	[action] varchar(1) COLLATE Latin1_General_CI_AS NOT NULL,
	created_by varchar(20) COLLATE Latin1_General_CI_AS NULL,
	processed varchar(1) COLLATE Latin1_General_CI_AS NULL
);

CREATE TABLE dbo.workflow_actions (
    workflow_action_id     INT            NOT NULL,
    main_entity_id         INT            NOT NULL,
    source_entity_id       INT            NULL,
    Operation_id           VARCHAR(200)   NOT NULL,
    load_start_date        DATETIME       NULL,
    CONSTRAINT workflow_actions_pk PRIMARY KEY (workflow_action_id);
