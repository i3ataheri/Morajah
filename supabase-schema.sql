-- ============================================
-- نظام الحضور والغياب الأسبوعي - Supabase Schema
-- ============================================

-- جدول الأعضاء
CREATE TABLE IF NOT EXISTS members (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name TEXT NOT NULL,
  pin TEXT NOT NULL UNIQUE,
  is_admin BOOLEAN DEFAULT false,
  created_at TIMESTAMPTZ DEFAULT now()
);

-- جدول الحضور والغياب
CREATE TABLE IF NOT EXISTS attendance (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  member_id UUID NOT NULL REFERENCES members(id) ON DELETE CASCADE,
  week_start DATE NOT NULL,
  status TEXT NOT NULL CHECK (status IN ('present', 'absent', 'excused', 'new_member')),
  marked_by UUID REFERENCES members(id),
  created_at TIMESTAMPTZ DEFAULT now(),
  UNIQUE(member_id, week_start)
);

-- فهارس البحث السريع
CREATE INDEX IF NOT EXISTS idx_attendance_week ON attendance(week_start);
CREATE INDEX IF NOT EXISTS idx_attendance_member ON attendance(member_id);
CREATE INDEX IF NOT EXISTS idx_members_pin ON members(pin);

-- الأمان (RLS) - معطّل للبساطة
ALTER TABLE members ENABLE ROW LEVEL SECURITY;
ALTER TABLE attendance ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow all for anonymous" ON members FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all for anonymous" ON attendance FOR ALL USING (true) WITH CHECK (true);

-- ============================================
-- بيانات تجريبية (اختيارية)
-- ============================================

-- مدير النظام بالرمز 1234
INSERT INTO members (name, pin, is_admin) VALUES ('مدير النظام', '1234', true)
ON CONFLICT (pin) DO NOTHING;
