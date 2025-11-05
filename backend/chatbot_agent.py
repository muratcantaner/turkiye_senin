import numpy as np
import faiss
from sentence_transformers import SentenceTransformer

# 1. Adım: Modeli ve Veriyi Yükleme
print("Embedding modeli (MiniLM) yükleniyor...")
model = SentenceTransformer('paraphrase-multilingual-MiniLM-L12-v2')

etkinlikler = [
    "Yapay zeka ve makine öğrenimi üzerine derinlemesine bir atölye.", # ID 0
    "İstanbul'da gerçekleştirilecek bu konserde rock müziğin efsaneleri sahne alacak.", # ID 1
    "Girişimciler için finansal planlama ve yatırımcı ilişkileri eğitimi.", # ID 2
    "Yeni başlayanlar için Python programlama ve kodlama kursu.", # ID 3
    "Veri bilimi ve AI'a giriş: Pratik uygulamalar ve vaka çalışmaları.", # ID 4
]

# ==================================================================
# FAZ 1: ENDEKSLEME (CPU üzerinde)
# ==================================================================
print("Etkinlik açıklamaları vektörlere dönüştürülüyor...")
etkinlik_vektorleri = model.encode(etkinlikler)

# Vektör boyutu
d = etkinlik_vektorleri.shape[1]  # (384)

# Cosine Similarity için L2 normalizasyonu
faiss.normalize_L2(etkinlik_vektorleri)

# 3. Adım: FAISS Index'ini Oluşturma (Sadece CPU)
# GPU'ya taşıma yok, direkt 'IndexFlatIP' kullanıyoruz.
index = faiss.IndexFlatIP(d)   
index.add(etkinlik_vektorleri)   # Vektörleri indekse ekle

print(f"\n{index.ntotal} adet etkinlik vektörü FAISS (CPU) indeksine eklendi.")

# ==================================================================
# FAZ 2: SORGULAMA (CPU üzerinde)
# ==================================================================

kullanici_sorgusu = "AI konulu bir atölye arıyorum"
k = 3  # En yakın 3 sonucu getir

print("\n-------------------------------------------")
print(f"KULLANICI SORGUSU: '{kullanici_sorgusu}'")
print(f"CPU üzerinde {k} sonuç aranıyor...")

# Sorguyu vektöre çevir ve normalize et
sorgu_vektoru = model.encode([kullanici_sorgusu])
faiss.normalize_L2(sorgu_vektoru)

# Arama (Direkt 'index' üzerinden)
D, I = index.search(sorgu_vektoru, k)

# Sonuçları Gösterme
print("\n✅ ARAMA SONUÇLARI:\n")
for i in range(k):
    index_id = I[0][i]
    benzerlik_skoru = D[0][i]
    
    # Eğer ID, etkinlik listesinin dışındaysa (k > etkinlik sayısı ise)
    if index_id >= len(etkinlikler): 
        continue
        
    print(f"  {i+1}. Sonuç (ID: {index_id}) | Benzerlik Skoru: {benzerlik_skoru:.4f}")
    print(f"     Etkinlik: {etkinlikler[index_id]}\n")