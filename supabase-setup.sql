-- ══════════════════════════════════════
-- MENUDZ · Supabase Database Setup
-- Run this in Supabase SQL Editor
-- ══════════════════════════════════════

-- 1. Create menu_items table
CREATE TABLE menu_items (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  name_fr TEXT NOT NULL,
  name_ar TEXT NOT NULL,
  desc_fr TEXT,
  desc_ar TEXT,
  category TEXT NOT NULL,
  emoji TEXT DEFAULT '🍕',
  prices JSONB NOT NULL DEFAULT '{}',
  photo_url TEXT,
  available BOOLEAN DEFAULT true,
  featured BOOLEAN DEFAULT false,
  sort_order INTEGER DEFAULT 0,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Create restaurant_info table
CREATE TABLE restaurant_info (
  id INTEGER PRIMARY KEY DEFAULT 1,
  name_fr TEXT DEFAULT 'Pizza Napoli',
  name_ar TEXT DEFAULT 'بيتزا نابولي',
  tagline_fr TEXT DEFAULT 'Pizzeria · Oran',
  tagline_ar TEXT DEFAULT 'بيتزاريا · وهران',
  phone TEXT DEFAULT '0550 123 456',
  address_fr TEXT DEFAULT 'Hai Fellaoucene, Oran',
  address_ar TEXT DEFAULT 'حي فلاوسن، وهران',
  hours TEXT DEFAULT '11h – 23h',
  wifi TEXT DEFAULT 'napoli2024',
  rating TEXT DEFAULT '4.9',
  offer_fr TEXT DEFAULT 'Pizza + Boisson + Frites',
  offer_ar TEXT DEFAULT 'بيتزا + مشروب + بطاطا',
  offer_price TEXT DEFAULT '1200',
  offer_active BOOLEAN DEFAULT true,
  primary_color TEXT DEFAULT '#ff3b30',
  logo_url TEXT
);

-- 3. Insert default restaurant info
INSERT INTO restaurant_info (id) VALUES (1) ON CONFLICT DO NOTHING;

-- 4. Enable Row Level Security
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurant_info ENABLE ROW LEVEL SECURITY;

-- 5. Allow public read access (customers can see menu)
CREATE POLICY "Public can read menu_items" ON menu_items FOR SELECT USING (true);
CREATE POLICY "Public can read restaurant_info" ON restaurant_info FOR SELECT USING (true);

-- 6. Allow all operations for authenticated users (admin)
CREATE POLICY "Auth can do everything on menu_items" ON menu_items FOR ALL USING (auth.role() = 'authenticated');
CREATE POLICY "Auth can do everything on restaurant_info" ON restaurant_info FOR ALL USING (auth.role() = 'authenticated');

-- 7. Storage bucket for photos (run separately if needed)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('menu-photos', 'menu-photos', true);
-- CREATE POLICY "Public can view photos" ON storage.objects FOR SELECT USING (bucket_id = 'menu-photos');
-- CREATE POLICY "Auth can upload photos" ON storage.objects FOR INSERT WITH CHECK (bucket_id = 'menu-photos' AND auth.role() = 'authenticated');
-- CREATE POLICY "Auth can delete photos" ON storage.objects FOR DELETE USING (bucket_id = 'menu-photos' AND auth.role() = 'authenticated');

-- 8. Insert sample data
INSERT INTO menu_items (name_fr, name_ar, desc_fr, desc_ar, category, emoji, prices, available, featured, sort_order) VALUES
('Margherita Classique', 'مارغريتا كلاسيك', 'Tomate fraîche, mozzarella fondante, basilic. La recette originale napolitaine.', 'طماطم طازجة، موزاريلا ذائبة، ريحان. الوصفة الأصلية النابولية.', 'pizzas', '🍕', '{"M": 850, "L": 1050, "XL": 1300}', true, true, 1),
('Poulet Grillé', 'دجاج مشوي', 'Poulet mariné grillé, poivrons, oignons, sauce barbecue maison.', 'دجاج مشوي متبل، فلفل رومي، بصل، صلصة باربيكيو منزلية.', 'pizzas', '🍗', '{"M": 1000, "L": 1200, "XL": 1450}', true, false, 2),
('4 Fromages', 'أربعة أجبان', 'Mozzarella, cheddar, gouda et fromage fondu. Pour les vrais amateurs.', 'موزاريلا، شيدر، غودا وجبن ذائب. لعشاق الجبن الحقيقيين.', 'pizzas', '🧀', '{"M": 1100, "L": 1300, "XL": 1550}', true, false, 3),
('Napoli Burger', 'برغر نابولي', 'Steak haché 180g, double cheddar, sauce napoli, oignons croustillants.', 'ستيك 180غ، شيدر مضاعف، صلصة نابولي، بصل مقرمش.', 'burgers', '🍔', '{"Normal": 850, "XL": 1050}', true, true, 1),
('Crispy Chicken', 'دجاج مقرمش', 'Filet de poulet pané croustillant, salade, sauce ranch et fromage fondu.', 'فيليه دجاج مقرمش، سلطة، صلصة رانش وجبن ذائب.', 'burgers', '🍗', '{"Normal": 800, "XL": 980}', true, false, 2),
('Sandwich Poulet', 'ساندويش دجاج', 'Baguette croustillante, poulet grillé, tomate, salade, sauce blanche.', 'باغيت مقرمش، دجاج مشوي، طماطم، سلطة، صلصة بيضاء.', 'sandwichs', '🥖', '{"Simple": 400, "Double": 550}', true, false, 1),
('Spaghetti Bolognaise', 'سباغيتي بولونيز', 'Spaghetti al dente, sauce bolognaise maison mijotée 3h, parmesan râpé.', 'سباغيتي، صلصة بولونيز منزلية مطبوخة 3 ساعات، بارميزان مبشور.', 'pates', '🍝', '{"Normal": 750, "Large": 950}', true, true, 1),
('Frites Maison', 'بطاطا منزلية', 'Pommes de terre fraîches coupées à la main, croustillantes et légères.', 'بطاطا طازجة مقطعة يدوياً، مقرمشة وخفيفة.', 'sides', '🍟', '{"Small": 200, "Large": 320}', true, false, 1),
('Coca-Cola / Pepsi', 'كوكا كولا / بيبسي', 'Canette bien fraîche.', 'علبة باردة.', 'boissons', '🥤', '{"33cl": 120, "50cl": 180}', true, false, 1),
('Limonade Maison', 'ليموناضة منزلية', 'Citron pressé, menthe fraîche, sirop de sucre et eau pétillante.', 'ليمون معصور، نعناع طازج، شراب سكر وماء فوار.', 'boissons', '🍋', '{"Single": 220}', true, false, 2);

SELECT 'Setup complete! ✅' as status;
