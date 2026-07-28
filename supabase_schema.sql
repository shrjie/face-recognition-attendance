-- ============================================
-- 班級人臉辨識簽到系統 — Supabase 資料表
-- 請在 Supabase Dashboard > SQL Editor 執行
-- ============================================

-- 1. 學生臉部資料
CREATE TABLE students (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  klass TEXT DEFAULT '',
  descriptor JSONB NOT NULL
);

-- 2. 簽到紀錄
CREATE TABLE records (
  id BIGSERIAL PRIMARY KEY,
  student_id TEXT REFERENCES students(id),
  name TEXT NOT NULL,
  klass TEXT DEFAULT '',
  timestamp TIMESTAMPTZ NOT NULL,
  status TEXT DEFAULT 'ontime'
);

-- 3. 系統設定（key-value）
CREATE TABLE settings (
  key TEXT PRIMARY KEY,
  value TEXT NOT NULL
);

INSERT INTO settings (key, value) VALUES
  ('teacher_hash', ''),
  ('reg_enabled', 'true'),
  ('attend_enabled', 'true'),
  ('audio_enabled', 'true'),
  ('class_time', '08:00'),
  ('threshold', '0.5');

-- 4. 上課日曆
CREATE TABLE school_calendar (
  date DATE PRIMARY KEY
);

-- 5. 上帝模式使用紀錄
CREATE TABLE god_mode_log (
  id BIGSERIAL PRIMARY KEY,
  time TIMESTAMPTZ DEFAULT now(),
  context TEXT
);

-- 6. Row Level Security（RLS）
ALTER TABLE students ENABLE ROW LEVEL SECURITY;
ALTER TABLE records ENABLE ROW LEVEL SECURITY;
ALTER TABLE settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE school_calendar ENABLE ROW LEVEL SECURITY;
ALTER TABLE god_mode_log ENABLE ROW LEVEL SECURITY;

CREATE POLICY "allow_all" ON students FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON records FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON settings FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON school_calendar FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "allow_all" ON god_mode_log FOR ALL USING (true) WITH CHECK (true);

-- 7. 簽到紀錄索引（加速查詢）
CREATE INDEX idx_records_timestamp ON records (timestamp);
CREATE INDEX idx_records_student_id ON records (student_id);
CREATE INDEX idx_records_status ON records (status);
