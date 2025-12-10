-- SECTION 2 — RLS & Policies Test (30 minutes)
-- Task:
-- Write RLS policies for:
-- Goal:
-- A counselor should only be able to read leads that are either:
-- • assigned to them, OR
-- • assigned to their team
-- But Admins can read all leads.
-- Inputs:
-- • leads.owner_id = counselor user id
-- • user_teams(user_id, team_id)
-- • teams(team_id)
-- • user role in JWT (auth.jwt() -> role: "admin" or "counselor")
-- Deliverables:
-- • RLS row policy for SELECT on leads
-- • RLS row policy for INSERT on leads

-- security policies for leads table

ALTER TABLE leads ENABLE ROW LEVEL SECURITY;

CREATE POLICY "read_leads" ON leads
FOR SELECT
USING (
    (auth.jwt() ->> 'role') = 'admin'
    OR owner_id = auth.uid()
    OR owner_id IN (
        SELECT ut2.user_id
        FROM user_teams ut1
        JOIN user_teams ut2 ON ut1.team_id = ut2.team_id
        WHERE ut1.user_id = auth.uid()
    )
);

CREATE POLICY "create_leads" ON leads
FOR INSERT
WITH CHECK (
    (auth.jwt() ->> 'role') = 'admin'
    OR owner_id = auth.uid()
    OR owner_id IN (
        SELECT ut2.user_id
        FROM user_teams ut1
        JOIN user_teams ut2 ON ut1.team_id = ut2.team_id
        WHERE ut1.user_id = auth.uid()
    )
);