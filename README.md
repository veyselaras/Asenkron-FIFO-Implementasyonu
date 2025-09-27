# Cliff Cummings Asenkron FIFO Tasarımı

Asenkron FIFO (First-In-First-Out), farklı saat alanlarında (clock domains) çalışan sistemler arasında veri transferini güvenli ve etkin bir şekilde gerçekleştirmek için kullanılan bir dijital tasarım bloğudur. Cliff Cummings, asenkron FIFO tasarımı konusunda endüstri standardı kabul edilen yöntemler sunmuş ve bu alanda önemli katkılar sağlamıştır. Bu README, Cummings'in asenkron FIFO tasarım prensiplerini ve kullanım alanlarını özetlemektedir.

## Asenkron FIFO Nedir?
Asenkron FIFO, bir saat alanından (yazma saati) veri yazılan ve başka bir saat alanından (okuma saati) veri okunan bir bellek yapısıdır. Temel amacı, farklı frekansta veya fazda çalışan iki sistem arasında veri senkronizasyonunu sağlamaktır. Bu tasarım, metastabilite risklerini azaltmak için senkronizasyon devreleri ve Gray kod gibi özel teknikler kullanır.

## Cliff Cummings'in Tasarım İlkeleri
Cliff Cummings'in asenkron FIFO tasarımı, aşağıdaki temel prensiplere dayanır:
- **Gray Kod Kullanımı**: Yazma ve okuma işaretçileri (pointers) Gray kod formatında kodlanır. Bu, saat alanları arasında geçiş yaparken bit değişimlerinin en aza indirilmesini sağlar ve metastabilite riskini azaltır.
- **Senkronizasyon**: Yazma işaretçisi okuma saat alanına, okuma işaretçisi ise yazma saat alanına senkronize edilir. Bu işlem genellikle iki aşamalı flip-flop senkronizatörlerle yapılır.
- **Boş/Dolu Durum Kontrolü**: FIFO'nun boş (empty) veya dolu (full) olduğunu belirlemek için işaretçi karşılaştırmaları yapılır. Cummings, bu kontrollerin doğru ve güvenilir bir şekilde yapılmasını sağlayan algoritmalar sunar.
- **Modüler Tasarım**: FIFO tasarımı, yeniden kullanılabilir ve farklı uygulamalara kolayca uyarlanabilir şekilde modülerdir.

## Kullanım Alanları
Asenkron FIFO'lar, aşağıdaki alanlarda yaygın olarak kullanılır:
- **Farklı Saat Alanları Arasında Veri Transferi**: İşlemciler, bellek birimleri veya iletişim arayüzleri arasında veri aktarımı.
- **Sistem Entegrasyonu**: FPGA veya ASIC tabanlı sistemlerde farklı protokoller veya modüller arasında veri köprüsü oluşturma.
- **İletişim Sistemleri**: Ethernet, USB veya diğer yüksek hızlı seri protokollerde veri tamponlama.
- **Gerçek Zamanlı İşleme**: Sensör verilerinin veya akış verilerinin farklı hızlarda işlenmesi.

# Test Sonuçları

### tb_async_fifo_rtl_empty sonuçları:
<img width="1799" height="190" alt="image" src="https://github.com/user-attachments/assets/9b2fb0a4-fef8-4f31-997c-88763e2aa949" />

### tb_async_fifo_rtl_full sonuçları:
<img width="1807" height="198" alt="image" src="https://github.com/user-attachments/assets/ce0772a3-1c9f-4a14-b0ce-c7ea68a59280" />

### tb_async_fifo_rtl_gray_sync sonuçları:
<img width="1692" height="254" alt="image" src="https://github.com/user-attachments/assets/a6ff47e5-0fc2-4f80-bf7e-0a45d168708a" />
- Buradaki sinyal kaymaları domainler arası farktan dolayı oluşmuştur.

### tb_async_fifo_rtl_mem sonuçları:
<img width="1808" height="259" alt="image" src="https://github.com/user-attachments/assets/3828d2f6-9b54-4ecc-b581-234f865b9347" />

### tb_async_fifo_rtl_reset_sync sonuçları:
<img width="1884" height="163" alt="image" src="https://github.com/user-attachments/assets/f9eef5b4-f650-4234-a08c-09c8ae11fa41" />
- Burada sync_rstn sinyali metastabilite oluşmasına karşın 2FF synchronizer'dan geçirilmişstir bundan ötürü gecikme oluşmuştur.

### tb_async_fifo_rtl_top sonuçları:
<img width="1871" height="299" alt="image" src="https://github.com/user-attachments/assets/0a362388-0ba9-4567-997b-f3ecf7fbfdf6" />






# Faydalandığım kaynaklar:

  ->https://www.youtube.com/playlist?list=PL6jcjOP0HjMpLtYgpWJzhe4uPfGimq0Cy
  
  ->https://zipcpu.com/blog/2018/07/06/afifo.html
  
  ->https://vlsiverify.com/verilog/verilog-codes/asynchronous-fifo/
  
  ->https://www.verilogpro.com/asynchronous-fifo-design/
  
  ->https://www.paradigm-works.com/technical-library?term=simulation+and+synthesis+techniques+for+asynchronous+fifo+design
  
  ->https://www.ti.com/lit/an/scaa042a/scaa042a.pdf
