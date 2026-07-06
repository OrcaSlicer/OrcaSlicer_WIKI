# OrcaSlicer Translation Glossary

Cross-language reference of key OrcaSlicer terms, to keep translations
**consistent** within each language. The base column is English (the `msgid`).

This is a companion to the [Localization and translation guide](localization_guide):
before translating a recurring term, check here for the established form so the
same English word is always rendered the same way within a language.

- [Kept in English (do not translate)](#kept-in-english-do-not-translate)
- [Translation table glossary](#translation-table-glossary)
- [Language specifics](#language-specifics)

> This table is derived from the `.po` files. When a term's established
> translation changes, update both the relevant `.po` files and this table so
> they stay in sync.

---

## Kept in English (do not translate)

These are written verbatim in the `msgstr` in essentially all languages.
Languages with non-Latin scripts (ja, ko, zh, ru, uk, th) keep the Latin
acronyms/brand names but may add a translated descriptor.

| Term | What it is, and why it stays in English |
| --- | --- |
| **OrcaSlicer** / Orca Slicer | The application's own name. Product and brand names are proper nouns and are never translated. |
| **Bambu Lab** / Bambu | Printer manufacturer brand. Proper noun. |
| **Orca Cloud**, **Bambu Cloud** | Names of the cloud sync/print services. Product names, kept as-is so they match the UI and account pages. |
| **Micro-Lidar** | Bambu Lab's branded calibration sensor. Trademark / product name. |
| **WebView2 Runtime** | Microsoft's embedded-browser component. Official product name — translating it would stop users from finding and installing it. |
| **AMS** | *Automatic Material System* — Bambu Lab's automatic filament changer. Established product acronym used worldwide. |
| **G-code** / G-Code | The machine-control language sent to the printer. Universal, industry-standard name. |
| **FDM** | *Fused Deposition Modeling* - the filament printing process. Standard technology acronym. |
| **SLA** | *Stereolithography* — the resin printing process. Standard technology acronym. |
| **HRC** | Rockwell C hardness scale, used for nozzle hardness. International measurement unit. |
| **LAN**, **IP**, **FTP**, **HTTPS** | Networking acronyms (local network, Internet Protocol, file transfer, secure HTTP). Universal technical acronyms. |
| **RAID** | *Redundant Array of Independent Disks* — a storage configuration. Standard acronym. |
| **SD** | *Secure Digital* memory-card standard. The acronym stays; the surrounding word may be translated (e.g. *tarjeta SD*). |
| **UTF-8** / UTF8 | Unicode text-encoding standard. Standard name. |
| **I3**, **CoreXY**, **H-bot**, **Delta** | Printer motion-system / frame types (I3 is Prusa i3 style; CoreXY and H-bot are belt arrangements; Delta is the parallel-arm type). Established machine-design names. |
| **Arachne** | Name of variable-width wall-generation engine. Proper name of the algorithm. |
| **Pressure Advance** | Firmware feature that compensates for extrusion-pressure lag. Established firmware term shared across slicers and firmware — kept in English so it matches firmware settings and documentation. |
| **Bowden** | Extruder drive type, named after the Bowden cable. Proper noun / established term. |
| **File formats**: 3MF, STL, STEP, OBJ, AMF, ZIP | File-format names and extensions. Extensions are fixed identifiers, not words, so they are never translated. |
| **Materials**: PLA, PETG, TPU, ABS, ASA, PC, PA, PVA, PEI | Polymer/material abbreviations (PEI is also the plate surface). International standard chemical abbreviations. |
| **G-code commands**: `M141`, `M191` | Literal printer commands (set / wait for chamber temperature). They are machine instructions and must be copied exactly. |
| **Macros & variables**: `PRINT_START`, `CHAMBER_TEMP`, `CHAMBER_MIN_TEMP`, `chamber_temperature`, `chamber_minimal_temperature` | Literal identifiers used in custom G-code. Translating or altering them breaks the macro/variable reference. |

## Translation table glossary

| English | de | es | fr | it | pt_BR | nl | ca | cs | pl | hu | lt | sv | tr | ru | uk | ja | ko | zh_CN | zh_TW | th | vi |
| --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
| **Infill** | Füllung | Relleno | Remplissage | Riempimento | Preenchimento | Vulling | Farciment | Výplň | Wypełnienie | Kitöltés | Užpildymas | Ifyllnad | Dolgu | Заполнение | Заповнення | インフィル | 채우기 | 填充 | 填充 | ไส้ใน | — |
| **Sparse infill** | Füllung | Relleno poco denso | Remplissage | Riempimento sparso | Preenchimento esparso | Dunne vulling (infill) | Farciment poc dens | Řídká výplň | Wypełnienie | Kitöltés | Retas užpildymas | Sparsam ifyllnad | Dolgu | Заполнение | Часткове заповнення | スパース インフィル | 드문 채우기 | 稀疏填充 | 稀疏填充 | ไส้ในแบบโปร่ง | Infill thưa |
| **Outer wall** | Außenwand | Perímetro externo | Paroi extérieure | Parete esterna | Parede externa | Buitenste wand | Perímetre exterior | Vnější stěna | Zewnętrzna ściana | Külső fal | Išorinė siena | Yttre vägg | Dış duvar | Внешние периметры | Зовнішня стінка | 外壁 | 외벽 | 外墙 | 外牆 | ผนังด้านนอก | Thành ngoài |
| **Inner wall** | Innere Wand | Perímetro interno | Paroi intérieure | Parete interna | Parede interna | Binnenste wand | Perímetre interior | Vnitřní stěna | Wewnętrzna ściana | Belső fal | Vidinė siena | Inre vägg | İç duvar | Внутренние периметры | Внутрішня стінка | 内壁 | 내벽 | 内墙 | 內牆 | ผนังด้านใน | Thành trong |
| **Brim** | Umrandung | Borde de adherencia | Bordure | Tesa | Borda | Rand | Vora d'Adherència | Límec | — | Perem | Kraštas | — | Kenar | Кайма | Кайма | ブリム | 브림 | Brim | 邊緣 | ขอบยึดชิ้นงาน | — |
| **Skirt** | Saum | Falda | Jupe | Gonna | Saia | — | Faldilla | Okraj | — | Szoknya | Apvadas | — | Etek | Юбка | Спідниця | スカート | 스커트 | 裙边 | Skirt | เส้นล้อมชิ้นงาน | Viền |
| **Raft** | Druckbasis (Raft) | Balsa/capa base de impresión | Radeau | Zattera | Jangada | Vlot | Vora d'Adherència | — | Tratwa (raft) | Tutaj | Platforma | — | — | Подложка | Підкладка | ラフト | 라프트 | 筏层 | 筏層 | ฐานรองชิ้นงาน | Bè |
| **Prime tower** | Reinigungsturm | Torre de Purga | Tour d’amorçage | Torre di spurgo | Torre de preparo | Prime toren | Torre de Purga | Základní věž | Wieża czyszcząca | Törlőtorony | Valymo bokštas | Prime torn | Prime Kulesi | Черновая башня | Підготовча вежа | プライムタワー | 프라임 타워 | 擦拭塔 | 換料塔 | ทาวเวอร์ไล่เส้น | — |
| **Bridge** | Überbrückung | Puente | Pont | Ponte | Ponte | Brug | Pont | Můstky | Mosty | Áthidalás | Tiltas | Bridge/bro | Köprü | Мосты | Міст | ブリッジ | 브릿지 | 桥接 | 橋接 | สะพาน | Cầu |
| **Ironing** | Glätten | Alisado | Lissage | Stiratura | Alisamento | Strijken | Planxat | Vyhlazování | Prasowanie | Vasalás | Lyginimas | Strykning | Ütüleme | Разглаживание | Розгладжування | アイロン | 다림질 | 熨烫 | 熨燙 | รีดผิว | — |
| **Support** | Stützen | Soportes | Supports | Supporto | Suporte | Ondersteuning | Suport | Podpora | Podpora | Támasz | Atramos | — | Destek | Поддержки | Підтримки | サポート | 서포트 | 支撑 | 支撐 | ส่วนรองรับ | — |
| **Tree supports** | Baumstützen | Soportes de árbol | Supports arborescents | Supporti ad albero | Suportes de árvore | Boomondersteuningen | Suports d'arbre | Stromové podpěry | Drzewo | Fatámaszok | Medžio tipo atramos | — | Ağaç destekler | Древовидная поддержка | Органічні підтримки | ツリーサポート | 트리 서포트 | 树状支撑 | 樹狀支撐 | ส่วนรองรับแบบต้นไม้ | Support dạng cây |
| **Gap fill** | Lücken füllen | Rellenar huecos | Remplissage des espaces | Riempi spazio vuoto | Preenchimento de vão | Gatvulling | Farcir el buit | Vyplnění mezery | Wypełnianie szczelin | Hézagok kitöltése | Plyšių užpildymas | Gap fyllning | Boşluk doldurma | Заполнение щели | Заповнення прогалин | 隙間充填 | 간격 채우기 | 缝隙填充 | 縫隙填充 | เติมช่องว่าง | Lấp khe |
| **Fuzzy skin** | Fuzzy skin | Superficie rugosa | Surface irrégulière | Superficie ruvida | Textura difusa | Vage buitenkant | Pell difusa | — | Skóra fuzzy | Barázdált felület | Grublėtas paviršius | Ojämn Yta | Pütürlü Yüzey | Нечёткая оболочка | Шорстка Поверхня | ファジー壁面 | 퍼지 스킨 | 绒毛表面 | 絨毛表面 | ผิวฟัซซี | — |
| **Nozzle** | Düse | Boquilla | Buse | Ugello | Bico | Mondstuk | Broquet( nozzle ) | Tryska | Dysza | Fúvóka | Purkštukas | Nozzel | Nozul | Экструдер | Сопло | ノズル | 노즐 | 喷嘴 | 噴嘴 | หัวฉีด | Đầu phun |
| **Extruder** | Extruder | Extrusor | Extrudeur | Estrusore | Extrusora | — | Extrusor | — | Ekstruder | — | Ekstruderis | — | Ekstruder | Экструдер | Екструдер | 押出機 | 압출기 | 挤出机 | 擠出機 | ชุดดันเส้น | — |
| **Extruder type** | Extruder Typ | Tipo de extrusor | Type d'extrudeur | Tipo di estrusore | Tipo de extrusora | Extrudertype | Tipus d'extrusora | Typ extruderu | Typ extrudera | Extruder típusa | Ekstruderio tipas | — | Ekstruder tipi | Тип подающего механизма | Тип екструдера | 押出機タイプ | 압출기 타입 | 挤出机类型 | 擠出機類型 | ประเภทชุดดันเส้น | Loại extruder |
| **Direct Drive** | Direktantrieb | Extrusor Directo | Entraînement direct | Direct Drive | Acionamento Direto | Direct Drive | Direct Drive | Direct Drive | Napęd bezpośredni | Direct Drive | Direct Drive | Direct Drive | Doğrudan Tahrik | Прямой (Direct) | Direct Drive | ダイレクトドライブ | 직접 드라이브 | 直驱（近程） | 直驅（近程） | ขับตรง | Direct Drive |
| **Bowden** | Bowden | Bowden | Bowden | Bowden | Tubo | Bowden | Bowden | Bowden | Bowden | Bowden | Bowden | Bowden | Bowden | Внешний (Bowden) | Боуден | ボーデン | 보우덴 | 远程挤出机 | 遠程擠出機 | โบว์เดน | Bowden |
| **Nozzle volume** | Volumen der Düse | Volumen de la boquilla | Volume de la buse | Volume ugello | Volume do bico | Mondstuk volume | Volum del broquet | Objem trysky | Objętość dyszy | Fúvóka térfogata | Purkštuko tūris | Nozzle volym | Nozul hacmi | Объём сопла | Об'єм сопла | 内腔容積 | 노즐 부피 | 喷嘴内腔体积 | 噴嘴內腔體積 | ปริมาณหัวฉีด | Thể tích đầu phun |
| **Bed** | Druckbett | Cama | Plateau | Piatto | Mesa | Printbed | Llit | Podložka | Stół | Asztal | Pagrindas | Byggplattan | Yatak | Стол | Стіл | ベッド | 베드 | 热床 | 列印板 | ฐานพิมพ์ | Bàn in |
| **Filament** | Filament | Filamento | Filament | Filamento | Filamento | — | — | — | — | — | Gija | — | — | Материал | Філамент | フィラメント | 필라멘트 | 耗材丝 | 線材 | เส้นพลาสติก | — |
| **Plate Type** | Druckbetttyp | Tipo de Cama | Type de plaque | Tipo di piatto | Tipo de Placa | — | Tipus de placa | Typ podložky | Typ Płyty | Tálcatípus | Plokštės tipas | Typ av byggplatta | Plaka Tipi | Покрытие | Тип Пластини | プレートタイプ | 플레이트 타입 | 热床类型 | 熱床類型 | ประเภทเพลต | Loại bàn |
| **Cool Plate** | Kalte Druckplatte | Cama Fría | Cool Plate/Plaque PLA | Piatto a bassa temperatura | Placa Fria | Cool (koud) printbed | Base Freda | Chladicí deska | Cool Plate / PLA Plate | — | Šalta plokštė | Kall platta | Soğuk plaka | Гладкое (низкотемп.) | Холодна пластина | 常温プレート | 쿨 플레이트 | 低温打印热床 | 低溫列印板 | จานเย็น | Bản Cool |
| **Engineering Plate** | Technische Druckplatte | Cama de Ingeniería | Plaque Engineering | Piatto ingegneristico | Placa de Engenharia | Engineering plate (technisch printbed) | Base d'Enginyeria | Inženýrská deska | — | Műszaki tálca | Inžinerinė plokštė | — | — | Инженерный лист Bambu | Інженерна Пластина | エンジニアリングプレート | 엔지니어링 플레이트 | 工程材料热床 | 工程列印板 | แผ่นวิศวกรรม | Bản Engineering |
| **Textured PEI Plate** | Texturierte PEI-Platte | Cama PEI Texturizada | Plaque PEI texturée | Piatto PEI ruvido | Placa PEI Texturizada | Getextureerde PEI-plaat | Base PEI amb Textura | Texturovaná PEI podložka | — | Texturált PEI tálca | Tekstūruota PEI plokštė | Texturerad PEI-platta | — | Текстурный лист с PEI | Текстурована PEI пластина | PEIプレート | 텍스처 PEI 플레이트 | 纹理PEI热床 | 紋理 PEI 列印板 | แผ่น PEI ที่มีพื้นผิว | Bản Textured PEI |
| **Slice** | Slicen | Laminar | Découper | Elabora | Fatiar | — | Llesca | Slicovat | — | Szeletelés | Sluoksniuoti | Bered | Dilimle | Нарезать | Нарізка | スライス | 슬라이스 | 切片 | 切片 | สไลซ์ | — |
| **Preset** | Profil | Perfil | Préréglage | Profilo | Predefinição | Voorinstelling | Perfil | Předvolba | Profil | Beállítás | Profilis | Förinställd | Ön ayar | Профиль | Шаблон | プリセット | 사전 설정 | 预设 | 預設 | พรีเซ็ต | Cài đặt sẵn |
| **Retraction** | Rückzug | Retracción | Rétraction | Retrazione | Retração | Terugtrekken (retraction) | Retracció | Retrakce | Retrakcja | Visszahúzás | Įtraukimas | Reduktion | Geri Çekme | Откат | Втягування | リトラクション | 후퇴 | 回抽 | 回抽 | การดึงกลับ | Rút |
| **Layer height** | Schichthöhe | Altura de la capa | Hauteur de couche | Altezza strato | Altura da camada | Laaghoogte | Alçada de capa | Výška vrstvy | Wysokość warstwy | Rétegmagasság | Sluoksnio aukštis | Lager höjd | Katman Yüksekliği | Высота слоя | Висота шару | 積層ピッチ | 레이어 높이 | 层高 | 層高 | ความสูงเลเยอร์ | Chiều cao lớp |
| **Chamber temperature** | Druckraum Temperatur | Temperatura de cámara | Température du caisson | Temperatura della camera | Temperatura da câmara | Kamertemperatuur | Temperatura de la cambra | Teplota komory | Temperatura komory | Kamra hőmérséklete | Kameros temperatūra | Kammarens temperatur | Bölme sıcaklığı | Температура термокамеры | Температура в камері | 庫内温度 | 챔버 온도 | 机箱温度 | 列印設備內部溫度 | อุณหภูมิห้องพิมพ์ | Nhiệt độ buồng |
| **Spiral vase** | Vasenmodus | Vaso en espiral | Vase spirale | Vaso a spirale | Vaso espiral | Spiraalvaas | Gerro en Espiral | Spirálová váza | Tryb wazy | Spirál (váza) | Spiralinė vaza | Spiral vas | Spiral vazo | Режим вазы | Спіральна ваза | スパイラル | 나선형 꽃병 모드 | 旋转花瓶 | 螺旋花瓶模式 | แจกันเกลียว | Bình xoắn ốc |
| **Gyroid** | Gyroid | Giroide | Gyroïde | Giroide | Giroide | Gyroide | Giroide | — | Gyroidalny | — | Giroidas | — | Jiroid | Гироид | Гіроїд | ジャイロイド | 자이로이드 | 螺旋体 | 螺旋體 | ไจรอยด์ | — |
| **Timelapse** | Zeitraffer | Timelapse | Timelapse | Timelapse | Timelapse | Timelapse | Timelapse | Časosběr | Timelapse | Timelapse | Greitintas vaizdo įrašas | Timelapse | Timelapse | Таймлапсы | Покадрова зйомка | タイムラプス | 타임랩스 | 延时摄影 | 縮時攝影 | ไทม์แลปส์ | Timelapse |

## Language specifics

This is a place for translators to specify some unique caracteristics for their translations.
