# データベース設計

## 使用データベース
SQLite3

## テーブル設計

### users テーブル
ユーザー認証用のテーブル

| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | INTEGER | PRIMARY KEY | ユーザーID |
| email | TEXT | UNIQUE, NOT NULL | メールアドレス |
| password_digest | TEXT | NOT NULL | ハッシュ化されたパスワード |
| created_at | TIMESTAMP | NOT NULL | 作成日時 |
| updated_at | TIMESTAMP | NOT NULL | 更新日時 |

### accounts テーブル
口座情報を管理するテーブル

| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | INTEGER | PRIMARY KEY | 口座ID |
| user_id | INTEGER | NOT NULL, FOREIGN KEY | ユーザーID |
| type | TEXT | NOT NULL | 口座タイプ（'mufg', 'rakuten_sec', 'daiwa_sec', 'other'） |
| name | TEXT | | 口座名（例：「メイン口座」） |
| description | TEXT | | 口座の説明 |
| created_at | TIMESTAMP | NOT NULL | 作成日時 |
| updated_at | TIMESTAMP | NOT NULL | 更新日時 |

**インデックス:**
- `idx_accounts_user_id` ON (user_id)

### account_snapshots テーブル
口座残高のスナップショットを記録するテーブル

| カラム名 | 型 | 制約 | 説明 |
|---------|-----|------|------|
| id | INTEGER | PRIMARY KEY | スナップショットID |
| account_id | INTEGER | NOT NULL, FOREIGN KEY | 口座ID |
| amount | INTEGER | NOT NULL | 金額（円） |
| recorded_at | TIMESTAMP | NOT NULL | 記録日時 |
| created_at | TIMESTAMP | NOT NULL | 作成日時 |

**インデックス:**
- `idx_snapshots_account_recorded` ON (account_id, recorded_at DESC)
- `idx_snapshots_recorded` ON (recorded_at DESC)

## パフォーマンス最適化

### 最新スナップショット取得
各口座の最新スナップショットを効率的に取得するために、以下のインデックスを活用：

```sql
-- 特定ユーザーの全口座の最新スナップショット取得
WITH latest_snapshots AS (
  SELECT 
    account_id,
    MAX(recorded_at) as max_recorded_at
  FROM account_snapshots
  WHERE account_id IN (
    SELECT id FROM accounts WHERE user_id = ?
  )
  GROUP BY account_id
)
SELECT 
  a.id,
  a.type,
  a.name,
  s.amount,
  s.recorded_at
FROM accounts a
JOIN account_snapshots s ON a.id = s.account_id
JOIN latest_snapshots ls ON s.account_id = ls.account_id 
  AND s.recorded_at = ls.max_recorded_at
WHERE a.user_id = ?;
```

### 総資産額の計算
```sql
-- ユーザーの総資産額を取得
WITH latest_snapshots AS (
  SELECT 
    account_id,
    MAX(recorded_at) as max_recorded_at
  FROM account_snapshots
  WHERE account_id IN (
    SELECT id FROM accounts WHERE user_id = ?
  )
  GROUP BY account_id
)
SELECT 
  SUM(s.amount) as total_amount
FROM account_snapshots s
JOIN latest_snapshots ls ON s.account_id = ls.account_id 
  AND s.recorded_at = ls.max_recorded_at;
```

### 口座別残高推移
```sql
-- 特定口座の残高推移を取得（直近N件）
SELECT 
  amount,
  recorded_at
FROM account_snapshots
WHERE account_id = ?
ORDER BY recorded_at DESC
LIMIT ?;
```

## 設計上の考慮点

1. **amount を INTEGER で管理**
   - 円単位で管理（小数点以下は扱わない）
   - JavaScriptの数値精度問題を回避

2. **account type の enum 値**
   - 'mufg': 三菱UFJ銀行
   - 'rakuten_sec': 楽天証券
   - 'daiwa_sec': 大和証券
   - 'other': その他

3. **recorded_at の使用**
   - ユーザーが任意のタイミングで記録
   - タイムスタンプベースで最新値を判定

4. **インデックス戦略**
   - 最新スナップショット取得のパフォーマンスを最優先
   - account_id と recorded_at の複合インデックスで高速化
