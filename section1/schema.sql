-- task:- Create the SQL schema for 3 tables, with constraints + indexes + relationships.
-- Tables:
-- 1. leads
-- 2. applications
-- 3. tasks
-- Requirements:
-- • Every table must include: id, tenant_id, created_at, updated_at
-- • applications references leads(id)
-- • tasks references applications(id) (as related_id)
-- • Add proper FOREIGN KEY constraints
-- • Add indexing for common queries:
-- o fetch leads by owner, stage, created_at
-- o fetch applications by lead
-- o fetch tasks due today
-- • Add a constraint:
-- o tasks.due_at >= created_at
-- • Add a check constraint:
-- o task.type IN (‘call’, ‘email’, ‘review’)
-- Deliverable:
-- A single .sql file that we should be able to run in Supabase.


CREATE TABLE leads (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    owner_id UUID,
    stage VARCHAR(50),
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255),
    phone VARCHAR(50),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE applications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    lead_id UUID NOT NULL,
    status VARCHAR(50),
    program VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (lead_id) REFERENCES leads(id) ON DELETE CASCADE
);

CREATE TABLE tasks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tenant_id UUID NOT NULL,
    related_id UUID NOT NULL,
    type VARCHAR(50) NOT NULL,
    title VARCHAR(255) NOT NULL,
    due_at TIMESTAMPTZ NOT NULL,
    status VARCHAR(50) DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    FOREIGN KEY (related_id) REFERENCES applications(id) ON DELETE CASCADE,
    CHECK (due_at >= created_at),
    CHECK (type IN ('call', 'email', 'review'))
);

CREATE INDEX idx_leads_owner ON leads(owner_id);
CREATE INDEX idx_leads_stage ON leads(stage);
CREATE INDEX idx_leads_created ON leads(created_at);
CREATE INDEX idx_apps_lead ON applications(lead_id);
CREATE INDEX idx_tasks_due ON tasks(due_at);

CREATE FUNCTION update_time()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER leads_time BEFORE UPDATE ON leads
    FOR EACH ROW EXECUTE FUNCTION update_time();

CREATE TRIGGER apps_time BEFORE UPDATE ON applications
    FOR EACH ROW EXECUTE FUNCTION update_time();

CREATE TRIGGER tasks_time BEFORE UPDATE ON tasks
    FOR EACH ROW EXECUTE FUNCTION update_time();