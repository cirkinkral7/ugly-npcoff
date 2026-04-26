# gladius-npcoff

Sunucunuzda ortam trafiğini, senaryo yayalarını, rastgele acil durum oluşumlarını ve **yapay zekâ dispatch** (polis, ambulans, itfaiye vb.) birimlerini azaltan hafif bir **FiveM** istemci kaynağıdır. Sürekli NPC araçları ve otomatik acil müdahale olmadan daha sakin bir dünya isteyen rol yapma veya etkinlik sunucuları için uygundur.

> **Not:** Bu kaynağın asıl kopyası  
> `resources/[gladius]/gladius-npcoff/`  
> altındadır. Bu `cache/files/` klasörü FiveM sunucusu kaynağı derlerken oluşturur; sunucuyu güncellediğinizde veya önbelleği temizlediğinizde **cache silinebilir**. Dokümantasyonun kalıcı olmasını istiyorsanız bu README’yi gerçek kaynak klasörünün yanına da kopyalayın.

---

## Ne işe yarar?

### İstemci (`client.lua`)

Her karede bir döngü çalışır ve yoğunluk ile dünya ayarlarını native’lerle uygular:

| Ayar | Etki |
|--------|--------|
| `SetVehicleDensityMultiplierThisFrame(0.0)` | Ortam sürüş trafiği yok. |
| `SetRandomVehicleDensityMultiplierThisFrame(0.0)` | Trafikte rastgele oluşan araçlar yok. |
| `SetParkedVehicleDensityMultiplierThisFrame(0.0)` | Park halindeki araçlar aynı şekilde ortamda oluşmaz. |
| `SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)` | Senaryo / “sahne” yayaları bastırılır. |
| `SetPedDensityMultiplierThisFrame(3.0)` | **Yürüyen** yaya yoğunluğu çarpanı yüksek (sıfır değil). Daha az yürüyen NPC isterseniz `client.lua` içinde bu değeri düşürün. |
| `SetGarbageTrucks(false)` | Çöp kamyonu oluşumlarını kapatır. |
| `SetRandomBoats(false)` | Rastgele tekneleri kapatır. |
| `SetCreateRandomCops` (varyantlar) | Rastgele polis ped oluşumunu durdurur. |
| `EnableDispatchService(i, false)` — `i = 1..15` | Dispatch hizmetlerini kapatır (dünya olaylarına otomatik polis/ambulans/itfaiye müdahalesi olmaz). |

Bu native’lerin **her karede** (veya çok sık) çağrılması gerekir; bu yüzden betik `Citizen.Wait(0)` kullanır.

### Sunucu (`server.lua`)

- **QBCore** ile başlar: `exports['qb-core']:GetCoreObject()`.
- Kaynak açıldığında **sunucu konsoluna** kısa bir onay satırı yazar (mevcut sürümde mesaj Türkçe).

Sunucu tarafı oyun yoğunluğu mantığını **çalıştırmaz**; tüm oyun içi etki **istemci tarafındadır**.

---

## Gereksinimler

- Standart GTA V / `cerulean` destekli **FiveM** sunucu artifact’ı.
- `server.lua` başlangıçta çekirdek nesnesini yüklediği için **QBCore** (`qb-core`) bu kaynaktan **önce** başlamalıdır.

Veritabanı veya ek varlık (asset) bağımlılığı yoktur.

---

## Kurulum (adım adım)

### 1. Kaynak konumu

Klasör yapısı şöyle olmalıdır:

```text
resources/
  [gladius]/
    gladius-npcoff/
      fxmanifest.lua
      client.lua
      server.lua
      storage/
        eslint_rc.js
```

Sunucunuzda zaten `ensure [gladius]` kullanılıyorsa, `[gladius]` içindeki tüm kaynaklar bu klasörle birlikte başlatılır.

### 2. `fxmanifest.lua`

Manifest şunlara referans vermelidir:

- `client_script 'client.lua'`
- `server_script 'server.lua'`
- `shared_scripts` içinde `storage/eslint_rc.js` (mevcut paketinizdeki gibi)

Manifest’i güncellemeden `client.lua` / `server.lua` dosya adlarını değiştirmeyin.

### 3. `server.cfg` yükleme sırası

1. Önce **QBCore**’u başlatın, örneğin:

   ```cfg
   ensure qb-core
   ```

2. Ardından Gladius paketini veya yalnızca bu kaynağı başlatın:

   ```cfg
   ensure [gladius]
   ```

   Köşeli parantezli tüm klasörü istemiyorsanız yalnızca:

   ```cfg
   ensure gladius-npcoff
   ```

**Önemli:** `gladius-npcoff`, `qb-core`’dan **sonra** başlamalıdır; aksi halde `server.lua` içinde `exports['qb-core']` çözülürken hata oluşabilir.

### 4. Yeniden başlatma

- Sunucuyu yeniden başlatın veya sunucu konsolunda:

  ```text
  ensure gladius-npcoff
  ```

- Oyuna girip doğrulayın: daha az trafik, dispatch spam’i yok; `server.lua`’dan gelen başlangıç mesajı için sunucu konsoluna bakın.

---

## Yapılandırma ipuçları

- **Daha az yürüyen NPC:** `client.lua` içinde `SetPedDensityMultiplierThisFrame(3.0)` değerini `0.0` veya `0.3` gibi küçük bir değere çekin ve kaynağı yeniden başlatın.
- **Belirli dispatch hizmetlerini tekrar açmak:** İlgili indeksler için `EnableDispatchService` çağrısını kaldırmanız veya seçerek `true` vermeniz gerekir (indeks anlamları için GTA/FiveM native dokümantasyonuna bakın).

---

## Sorun giderme

| Sorun | Olası neden |
|--------|----------------|
| Başlangıçta `qb-core` ile ilgili sunucu hatası | `qb-core` başlamamış veya export adı yanlış; yükleme sırasını düzeltin veya farklı bir çatı kullanıyorsanız export’u uyarlayın. |
| Oyunda etki yok | Kaynak başlamıyor veya başka bir betik aynı native’leri bu kaynaktan **sonra** her karede eziyor (kaynak sırasını düzenleyin). |
| Güncellemeden sonra README kayboldu | Yalnızca `cache/files/` altındaydı; kalıcı kopya için `readme-tr.md` / `readme.md` dosyalarını `resources/[gladius]/gladius-npcoff/` içine kopyalayın. |

---

## Krediler

`fxmanifest.lua`’a göre: **Gladius NPC ve Trafik Engelleyici** — yazarlar: Gemini & Cursor.

---

## Lisans

Orijinal paket bir lisans dosyasıyla geldiyse o dosyadaki şartlara uyun. Bu README yalnızca dokümantasyondur; kaynak yazarının lisans koşullarının yerine geçmez.
