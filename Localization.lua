local _, ns = ...

local L = {
    STATUS_KEEP = "KEEP",
    STATUS_EXCESS = "EXCESS AVAILABLE",
    STATUS_KEEP_FOR_NOW = "KEEP FOR NOW",
    STATUS_POSSIBLE_FUTURE = "POSSIBLE QUEST USE",
    STATUS_UNKNOWN = "QUEST USE UNKNOWN",
    STATUS_LIKELY_SAFE = "LIKELY SAFE TO DELETE",

    ACROSS_BAGS_REQUIRED = "Across bags: %d / %d required",
    STILL_NEED = "Still need %d more.",
    EXACT_AMOUNT = "Exact amount needed; do not discard any.",
    ACROSS_BAGS_OWNED = "Across bags: %d owned, %d required",
    UP_TO_DISCARD = "Up to %d can be discarded.",

    SOURCE_ITEM_ACTIVE = "QuestieDB marks this as a source item for an %s quest.",
    ACTIVE = "active",

    STARTS_UNFINISHED = "Starts an unfinished quest:",

    POSSIBLE_FUTURE_LINE1 = "Not needed by an active quest, but QuestieDB links it",
    POSSIBLE_FUTURE_LINE2 = "to unfinished quest(s). Don't auto-delete it.",

    UNKNOWN_LINE1 = "WoW marks this as a quest item, but its quest is not",
    UNKNOWN_LINE2 = "in the available quest database or your active quest log.",
    UNKNOWN_LINE3 = "Keep it unless you know the quest is finished.",

    LIKELY_SAFE_LINE = "No unfinished quest needs this item.",
    RELATED_COMPLETED = "Related %s quest(s):",
    COMPLETED = "completed",

    QUEST_LABEL = "Quest:",
    NEEDS = "(needs %d)",

    QUESTIE_NOT_LOADED = "QuestieDB is not loaded. Enable QuestieDB and reload the UI.",
    API_INCOMPATIBLE = "QuestieDB API is incompatible.",
    LOADED = "loaded. Hover quest-related items, or use /qil scan.",

    SCAN_KEEP = "KEEP %s — %d/%d, need %d more — %s",
    SCAN_EXCESS = "EXCESS %s — %d owned, %d required; %d discardable — %s",
    SCAN_STARTS = "KEEP %s — starts %s",
    SCAN_CHECK = "CHECK %s — linked to unfinished quest: %s",
    SCAN_ACTIVE_SUPPORT = "KEEP %s — active quest source item — %s",
    SCAN_LIKELY_SAFE = "LIKELY SAFE TO DELETE %s — no unfinished quest needs this item",
    SCAN_UNKNOWN = "UNKNOWN %s — WoW marks it as a quest item, but no quest mapping is available",
    SCAN_NONE = "No quest-related bag items found by QuestieDB.",
    ACTIVE_QUEST = "active quest",

    COMMANDS = "commands: /qil scan, /qil refresh",
    REFRESHED = "quest database index and active quest cache refreshed.",

    UNKNOWN_QUEST = "Unknown quest",
    QUEST_N = "Quest %d",
}

local localized = {
    deDE = {
        STATUS_KEEP = "BEHALTEN",
        STATUS_EXCESS = "ÜBERSCHUSS VORHANDEN",
        STATUS_KEEP_FOR_NOW = "VORERST BEHALTEN",
        STATUS_POSSIBLE_FUTURE = "MÖGLICHE QUEST-NUTZUNG",
        STATUS_UNKNOWN = "QUEST-NUTZUNG UNBEKANNT",
        STATUS_LIKELY_SAFE = "WAHRSCHEINLICH SICHER ZU LÖSCHEN",

        ACROSS_BAGS_REQUIRED = "Über alle Taschen: %d / %d benötigt",
        STILL_NEED = "Es fehlen noch %d.",
        EXACT_AMOUNT = "Genau die benötigte Menge; keines wegwerfen.",
        ACROSS_BAGS_OWNED = "Über alle Taschen: %d vorhanden, %d benötigt",
        UP_TO_DISCARD = "Bis zu %d können weggeworfen werden.",

        SOURCE_ITEM_ACTIVE = "QuestieDB markiert dies als Quellen-Gegenstand für eine %s Quest.",
        ACTIVE = "aktive",

        STARTS_UNFINISHED = "Startet eine unvollendete Quest:",

        POSSIBLE_FUTURE_LINE1 = "Wird von keiner aktiven Quest benötigt, aber QuestieDB verknüpft es",
        POSSIBLE_FUTURE_LINE2 = "mit unvollendeten Quest(s). Nicht automatisch löschen.",

        UNKNOWN_LINE1 = "WoW markiert dies als Quest-Gegenstand, aber dessen Quest ist nicht",
        UNKNOWN_LINE2 = "in der verfügbaren Quest-Datenbank oder im aktiven Questlog.",
        UNKNOWN_LINE3 = "Behalten, sofern du nicht weißt, dass die Quest abgeschlossen ist.",

        LIKELY_SAFE_LINE = "Keine unvollendete Quest benötigt diesen Gegenstand.",
        RELATED_COMPLETED = "Verknüpfte %s Quest(s):",
        COMPLETED = "abgeschlossene",

        QUEST_LABEL = "Quest:",
        NEEDS = "(benötigt %d)",

        QUESTIE_NOT_LOADED = "QuestieDB ist nicht geladen. Aktiviere QuestieDB und lade die UI neu.",
        API_INCOMPATIBLE = "QuestieDB-API ist inkompatibel.",
        LOADED = "geladen. Fahre über Quest-Gegenstände oder nutze /qil scan.",

        SCAN_KEEP = "BEHALTEN %s — %d/%d, es fehlen %d — %s",
        SCAN_EXCESS = "ÜBERSCHUSS %s — %d vorhanden, %d benötigt; %d wegwerfbar — %s",
        SCAN_STARTS = "BEHALTEN %s — startet %s",
        SCAN_CHECK = "PRÜFEN %s — verknüpft mit unvollendeter Quest: %s",
        SCAN_ACTIVE_SUPPORT = "BEHALTEN %s — Quellen-Gegenstand aktiver Quest — %s",
        SCAN_LIKELY_SAFE = "WAHRSCHEINLICH SICHER ZU LÖSCHEN %s — keine unvollendete Quest benötigt diesen Gegenstand",
        SCAN_UNKNOWN = "UNBEKANNT %s — WoW markiert es als Quest-Gegenstand, aber keine Quest-Zuordnung verfügbar",
        SCAN_NONE = "Keine Quest-bezogenen Taschen-Gegenstände von QuestieDB gefunden.",
        ACTIVE_QUEST = "aktive Quest",

        COMMANDS = "Befehle: /qil scan, /qil refresh",
        REFRESHED = "Quest-Datenbankindex und aktiver Quest-Cache aktualisiert.",

        UNKNOWN_QUEST = "Unbekannte Quest",
        QUEST_N = "Quest %d",
    },

    frFR = {
        STATUS_KEEP = "GARDER",
        STATUS_EXCESS = "EXCÉDENT DISPONIBLE",
        STATUS_KEEP_FOR_NOW = "GARDER POUR L'INSTANT",
        STATUS_POSSIBLE_FUTURE = "USAGE DE QUÊTE POSSIBLE",
        STATUS_UNKNOWN = "USAGE DE QUÊTE INCONNU",
        STATUS_LIKELY_SAFE = "PROBABLEMENT SÛR À SUPPRIMER",

        ACROSS_BAGS_REQUIRED = "Dans tous les sacs : %d / %d requis",
        STILL_NEED = "Encore %d manquant(s).",
        EXACT_AMOUNT = "Quantité exacte requise ; n'en jetez aucun.",
        ACROSS_BAGS_OWNED = "Dans tous les sacs : %d possédé(s), %d requis",
        UP_TO_DISCARD = "Jusqu'à %d peut/peuvent être jeté(s).",

        SOURCE_ITEM_ACTIVE = "QuestieDB le marque comme objet source d'une quête %s.",
        ACTIVE = "active",

        STARTS_UNFINISHED = "Démarre une quête inachevée :",

        POSSIBLE_FUTURE_LINE1 = "Pas nécessaire pour une quête active, mais QuestieDB le relie",
        POSSIBLE_FUTURE_LINE2 = "à une/des quête(s) inachevée(s). Ne le supprimez pas automatiquement.",

        UNKNOWN_LINE1 = "WoW le marque comme objet de quête, mais sa quête n'est pas",
        UNKNOWN_LINE2 = "dans la base de données de quêtes disponible ou votre journal actif.",
        UNKNOWN_LINE3 = "Gardez-le sauf si vous savez que la quête est terminée.",

        LIKELY_SAFE_LINE = "Aucune quête inachevée n'a besoin de cet objet.",
        RELATED_COMPLETED = "Quête(s) %s liée(s) :",
        COMPLETED = "terminée(s)",

        QUEST_LABEL = "Quête :",
        NEEDS = "(nécessite %d)",

        QUESTIE_NOT_LOADED = "QuestieDB n'est pas chargé. Activez QuestieDB et rechargez l'interface.",
        API_INCOMPATIBLE = "L'API QuestieDB est incompatible.",
        LOADED = "chargé. Survolez les objets liés aux quêtes, ou utilisez /qil scan.",

        SCAN_KEEP = "GARDER %s — %d/%d, encore %d — %s",
        SCAN_EXCESS = "EXCÉDENT %s — %d possédé(s), %d requis ; %d jetable(s) — %s",
        SCAN_STARTS = "GARDER %s — démarre %s",
        SCAN_CHECK = "VÉRIFIER %s — lié à une quête inachevée : %s",
        SCAN_ACTIVE_SUPPORT = "GARDER %s — objet source d'une quête active — %s",
        SCAN_LIKELY_SAFE = "PROBABLEMENT SÛR À SUPPRIMER %s — aucune quête inachevée n'a besoin de cet objet",
        SCAN_UNKNOWN = "INCONNU %s — WoW le marque comme objet de quête, mais aucun mappage de quête disponible",
        SCAN_NONE = "Aucun objet de quête trouvé dans les sacs par QuestieDB.",
        ACTIVE_QUEST = "quête active",

        COMMANDS = "commandes : /qil scan, /qil refresh",
        REFRESHED = "index de la base de quêtes et cache des quêtes actives actualisés.",

        UNKNOWN_QUEST = "Quête inconnue",
        QUEST_N = "Quête %d",
    },

    esES = {
        STATUS_KEEP = "MANTENER",
        STATUS_EXCESS = "EXCEDENTE DISPONIBLE",
        STATUS_KEEP_FOR_NOW = "MANTENER POR AHORA",
        STATUS_POSSIBLE_FUTURE = "POSIBLE USO DE MISIÓN",
        STATUS_UNKNOWN = "USO DE MISIÓN DESCONOCIDO",
        STATUS_LIKELY_SAFE = "PROBABLEMENTE SEGURO DE ELIMINAR",

        ACROSS_BAGS_REQUIRED = "En todas las bolsas: %d / %d requerido",
        STILL_NEED = "Aún faltan %d más.",
        EXACT_AMOUNT = "Cantidad exacta necesaria; no descartes ninguno.",
        ACROSS_BAGS_OWNED = "En todas las bolsas: %d poseído, %d requerido",
        UP_TO_DISCARD = "Se pueden descartar hasta %d.",

        SOURCE_ITEM_ACTIVE = "QuestieDB lo marca como objeto fuente de una misión %s.",
        ACTIVE = "activa",

        STARTS_UNFINISHED = "Inicia una misión incompleta:",

        POSSIBLE_FUTURE_LINE1 = "No lo necesita una misión activa, pero QuestieDB lo vincula",
        POSSIBLE_FUTURE_LINE2 = "a misiones incompletas. No lo elimines automáticamente.",

        UNKNOWN_LINE1 = "WoW lo marca como objeto de misión, pero su misión no está",
        UNKNOWN_LINE2 = "en la base de datos disponible ni en tu registro de misiones activo.",
        UNKNOWN_LINE3 = "Mantenlo salvo que sepas que la misión terminó.",

        LIKELY_SAFE_LINE = "Ninguna misión incompleta necesita este objeto.",
        RELATED_COMPLETED = "Misiones %s relacionadas:",
        COMPLETED = "completadas",

        QUEST_LABEL = "Misión:",
        NEEDS = "(necesita %d)",

        QUESTIE_NOT_LOADED = "QuestieDB no está cargado. Activa QuestieDB y recarga la interfaz.",
        API_INCOMPATIBLE = "La API de QuestieDB es incompatible.",
        LOADED = "cargado. Pasa el cursor sobre objetos de misión o usa /qil scan.",

        SCAN_KEEP = "MANTENER %s — %d/%d, faltan %d — %s",
        SCAN_EXCESS = "EXCEDENTE %s — %d poseído, %d requerido; %d descartables — %s",
        SCAN_STARTS = "MANTENER %s — inicia %s",
        SCAN_CHECK = "REVISAR %s — vinculado a misión incompleta: %s",
        SCAN_ACTIVE_SUPPORT = "MANTENER %s — objeto fuente de misión activa — %s",
        SCAN_LIKELY_SAFE = "PROBABLEMENTE SEGURO DE ELIMINAR %s — ninguna misión incompleta necesita este objeto",
        SCAN_UNKNOWN = "DESCONOCIDO %s — WoW lo marca como objeto de misión, pero no hay mapeo de misión disponible",
        SCAN_NONE = "No se encontraron objetos de misión en las bolsas según QuestieDB.",
        ACTIVE_QUEST = "misión activa",

        COMMANDS = "comandos: /qil scan, /qil refresh",
        REFRESHED = "índice de base de misiones y caché de misiones activas actualizados.",

        UNKNOWN_QUEST = "Misión desconocida",
        QUEST_N = "Misión %d",
    },

    ptBR = {
        STATUS_KEEP = "MANTER",
        STATUS_EXCESS = "EXCEDENTE DISPONÍVEL",
        STATUS_KEEP_FOR_NOW = "MANTER POR ENQUANTO",
        STATUS_POSSIBLE_FUTURE = "POSSÍVEL USO EM MISSÃO",
        STATUS_UNKNOWN = "USO EM MISSÃO DESCONHECIDO",
        STATUS_LIKELY_SAFE = "PROVAVELMENTE SEGURO PARA EXCLUIR",

        ACROSS_BAGS_REQUIRED = "Em todas as bolsas: %d / %d necessário",
        STILL_NEED = "Ainda precisa de mais %d.",
        EXACT_AMOUNT = "Quantidade exata necessária; não descarte nenhum.",
        ACROSS_BAGS_OWNED = "Em todas as bolsas: %d possuído, %d necessário",
        UP_TO_DISCARD = "Até %d podem ser descartados.",

        SOURCE_ITEM_ACTIVE = "QuestieDB o marca como item-fonte de uma missão %s.",
        ACTIVE = "ativa",

        STARTS_UNFINISHED = "Inicia uma missão incompleta:",

        POSSIBLE_FUTURE_LINE1 = "Não é necessário para uma missão ativa, mas o QuestieDB o vincula",
        POSSIBLE_FUTURE_LINE2 = "a missão(ões) incompleta(s). Não exclua automaticamente.",

        UNKNOWN_LINE1 = "WoW o marca como item de missão, mas sua missão não está",
        UNKNOWN_LINE2 = "no banco de dados de missões disponível ou no seu registro ativo.",
        UNKNOWN_LINE3 = "Mantenha-o, a menos que saiba que a missão terminou.",

        LIKELY_SAFE_LINE = "Nenhuma missão incompleta precisa deste item.",
        RELATED_COMPLETED = "Missão(ões) %s relacionada(s):",
        COMPLETED = "concluída(s)",

        QUEST_LABEL = "Missão:",
        NEEDS = "(precisa de %d)",

        QUESTIE_NOT_LOADED = "QuestieDB não está carregado. Ative o QuestieDB e recarregue a interface.",
        API_INCOMPATIBLE = "A API do QuestieDB é incompatível.",
        LOADED = "carregado. Passe o mouse sobre itens de missão ou use /qil scan.",

        SCAN_KEEP = "MANTER %s — %d/%d, faltam %d — %s",
        SCAN_EXCESS = "EXCEDENTE %s — %d possuído, %d necessário; %d descartáveis — %s",
        SCAN_STARTS = "MANTER %s — inicia %s",
        SCAN_CHECK = "VERIFICAR %s — vinculado a missão incompleta: %s",
        SCAN_ACTIVE_SUPPORT = "MANTER %s — item-fonte de missão ativa — %s",
        SCAN_LIKELY_SAFE = "PROVAVELMENTE SEGURO PARA EXCLUIR %s — nenhuma missão incompleta precisa deste item",
        SCAN_UNKNOWN = "DESCONHECIDO %s — WoW o marca como item de missão, mas não há mapeamento de missão disponível",
        SCAN_NONE = "Nenhum item de missão encontrado nas bolsas pelo QuestieDB.",
        ACTIVE_QUEST = "missão ativa",

        COMMANDS = "comandos: /qil scan, /qil refresh",
        REFRESHED = "índice do banco de missões e cache de missões ativas atualizados.",

        UNKNOWN_QUEST = "Missão desconhecida",
        QUEST_N = "Missão %d",
    },

    itIT = {
        STATUS_KEEP = "TENERE",
        STATUS_EXCESS = "ECCESSO DISPONIBILE",
        STATUS_KEEP_FOR_NOW = "TENERE PER ORA",
        STATUS_POSSIBLE_FUTURE = "POSSIBILE USO IN MISSIONE",
        STATUS_UNKNOWN = "USO IN MISSIONE SCONOSCIUTO",
        STATUS_LIKELY_SAFE = "PROBABILMENTE SICURO DA ELIMINARE",

        ACROSS_BAGS_REQUIRED = "In tutte le borse: %d / %d richiesti",
        STILL_NEED = "Ne servono ancora %d.",
        EXACT_AMOUNT = "Quantità esatta necessaria; non scartarne nessuno.",
        ACROSS_BAGS_OWNED = "In tutte le borse: %d posseduti, %d richiesti",
        UP_TO_DISCARD = "È possibile scartarne fino a %d.",

        SOURCE_ITEM_ACTIVE = "QuestieDB lo contrassegna come oggetto sorgente per una missione %s.",
        ACTIVE = "attiva",

        STARTS_UNFINISHED = "Avvia una missione incompleta:",

        POSSIBLE_FUTURE_LINE1 = "Non serve a una missione attiva, ma QuestieDB lo collega",
        POSSIBLE_FUTURE_LINE2 = "a missioni incomplete. Non eliminarlo automaticamente.",

        UNKNOWN_LINE1 = "WoW lo contrassegna come oggetto di missione, ma la sua missione non è",
        UNKNOWN_LINE2 = "nel database missioni disponibile o nel tuo registro missioni attivo.",
        UNKNOWN_LINE3 = "Tienilo a meno che tu non sappia che la missione è finita.",

        LIKELY_SAFE_LINE = "Nessuna missione incompleta richiede questo oggetto.",
        RELATED_COMPLETED = "Missioni %s correlate:",
        COMPLETED = "completate",

        QUEST_LABEL = "Missione:",
        NEEDS = "(richiede %d)",

        QUESTIE_NOT_LOADED = "QuestieDB non è caricato. Abilita QuestieDB e ricarica l'interfaccia.",
        API_INCOMPATIBLE = "L'API di QuestieDB è incompatibile.",
        LOADED = "caricato. Passa sopra gli oggetti legati alle missioni o usa /qil scan.",

        SCAN_KEEP = "TENERE %s — %d/%d, ne mancano %d — %s",
        SCAN_EXCESS = "ECCESSO %s — %d posseduti, %d richiesti; %d scartabili — %s",
        SCAN_STARTS = "TENERE %s — avvia %s",
        SCAN_CHECK = "CONTROLLARE %s — collegato a missione incompleta: %s",
        SCAN_ACTIVE_SUPPORT = "TENERE %s — oggetto sorgente di missione attiva — %s",
        SCAN_LIKELY_SAFE = "PROBABILMENTE SICURO DA ELIMINARE %s — nessuna missione incompleta richiede questo oggetto",
        SCAN_UNKNOWN = "SCONOSCIUTO %s — WoW lo contrassegna come oggetto di missione, ma non c'è mappatura della missione disponibile",
        SCAN_NONE = "Nessun oggetto di missione trovato nelle borse da QuestieDB.",
        ACTIVE_QUEST = "missione attiva",

        COMMANDS = "comandi: /qil scan, /qil refresh",
        REFRESHED = "indice del database missioni e cache missioni attive aggiornati.",

        UNKNOWN_QUEST = "Missione sconosciuta",
        QUEST_N = "Missione %d",
    },

    ruRU = {
        STATUS_KEEP = "ОСТАВИТЬ",
        STATUS_EXCESS = "ЕСТЬ ЛИШНИЕ",
        STATUS_KEEP_FOR_NOW = "ПОКА ОСТАВИТЬ",
        STATUS_POSSIBLE_FUTURE = "ВОЗМОЖНО НУЖЕН ДЛЯ ЗАДАНИЯ",
        STATUS_UNKNOWN = "НАЗНАЧЕНИЕ В ЗАДАНИИ НЕИЗВЕСТНО",
        STATUS_LIKELY_SAFE = "СКОРЕЕ ВСЕГО МОЖНО УДАЛИТЬ",

        ACROSS_BAGS_REQUIRED = "Во всех сумках: %d / %d требуется",
        STILL_NEED = "Нужно ещё %d.",
        EXACT_AMOUNT = "Ровно нужное количество; ничего не выбрасывайте.",
        ACROSS_BAGS_OWNED = "Во всех сумках: %d есть, %d требуется",
        UP_TO_DISCARD = "Можно выбросить до %d.",

        SOURCE_ITEM_ACTIVE = "QuestieDB отмечает его как исходный предмет для %s задания.",
        ACTIVE = "активного",

        STARTS_UNFINISHED = "Начинает незавершённое задание:",

        POSSIBLE_FUTURE_LINE1 = "Не нужен для активного задания, но QuestieDB связывает его",
        POSSIBLE_FUTURE_LINE2 = "с незавершёнными заданиями. Не удаляйте автоматически.",

        UNKNOWN_LINE1 = "WoW отмечает его как предмет задания, но его задание отсутствует",
        UNKNOWN_LINE2 = "в доступной базе заданий или в вашем журнале заданий.",
        UNKNOWN_LINE3 = "Оставьте его, если не уверены, что задание завершено.",

        LIKELY_SAFE_LINE = "Ни одно незавершённое задание не требует этот предмет.",
        RELATED_COMPLETED = "Связанные %s задания:",
        COMPLETED = "завершённые",

        QUEST_LABEL = "Задание:",
        NEEDS = "(требуется %d)",

        QUESTIE_NOT_LOADED = "QuestieDB не загружен. Включите QuestieDB и перезагрузите интерфейс.",
        API_INCOMPATIBLE = "API QuestieDB несовместим.",
        LOADED = "загружен. Наводите курсор на предметы заданий или используйте /qil scan.",

        SCAN_KEEP = "ОСТАВИТЬ %s — %d/%d, нужно ещё %d — %s",
        SCAN_EXCESS = "ЛИШНЕЕ %s — %d есть, %d требуется; можно выбросить %d — %s",
        SCAN_STARTS = "ОСТАВИТЬ %s — начинает %s",
        SCAN_CHECK = "ПРОВЕРИТЬ %s — связано с незавершённым заданием: %s",
        SCAN_ACTIVE_SUPPORT = "ОСТАВИТЬ %s — исходный предмет активного задания — %s",
        SCAN_LIKELY_SAFE = "СКОРЕЕ ВСЕГО МОЖНО УДАЛИТЬ %s — ни одно незавершённое задание не требует этот предмет",
        SCAN_UNKNOWN = "НЕИЗВЕСТНО %s — WoW отмечает его как предмет задания, но сопоставление с заданием недоступно",
        SCAN_NONE = "QuestieDB не нашёл предметы заданий в сумках.",
        ACTIVE_QUEST = "активное задание",

        COMMANDS = "команды: /qil scan, /qil refresh",
        REFRESHED = "индекс базы заданий и кэш активных заданий обновлены.",

        UNKNOWN_QUEST = "Неизвестное задание",
        QUEST_N = "Задание %d",
    },

    koKR = {
        STATUS_KEEP = "보관",
        STATUS_EXCESS = "여분 있음",
        STATUS_KEEP_FOR_NOW = "당분간 보관",
        STATUS_POSSIBLE_FUTURE = "퀘스트에 사용될 수 있음",
        STATUS_UNKNOWN = "퀘스트 사용처 알 수 없음",
        STATUS_LIKELY_SAFE = "삭제해도 안전할 가능성 높음",

        ACROSS_BAGS_REQUIRED = "모든 가방 합계: %d / %d 필요",
        STILL_NEED = "%d개 더 필요합니다.",
        EXACT_AMOUNT = "필요한 만큼만 있음; 버리지 마세요.",
        ACROSS_BAGS_OWNED = "모든 가방 합계: %d개 보유, %d개 필요",
        UP_TO_DISCARD = "최대 %d개까지 버릴 수 있습니다.",

        SOURCE_ITEM_ACTIVE = "QuestieDB가 이 아이템을 %s 퀘스트의 원천 아이템으로 표시합니다.",
        ACTIVE = "진행 중인",

        STARTS_UNFINISHED = "완료되지 않은 퀘스트를 시작합니다:",

        POSSIBLE_FUTURE_LINE1 = "진행 중인 퀘스트에 필요하지 않지만 QuestieDB가",
        POSSIBLE_FUTURE_LINE2 = "완료되지 않은 퀘스트와 연결합니다. 자동으로 삭제하지 마세요.",

        UNKNOWN_LINE1 = "WoW가 이 아이템을 퀘스트 아이템으로 표시하지만 해당 퀘스트가",
        UNKNOWN_LINE2 = "사용 가능한 퀘스트 데이터베이스나 진행 중인 퀘스트 로그에 없습니다.",
        UNKNOWN_LINE3 = "퀘스트가 끝났다는 확신이 없으면 보관하세요.",

        LIKELY_SAFE_LINE = "완료되지 않은 퀘스트 중 이 아이템이 필요한 퀘스트가 없습니다.",
        RELATED_COMPLETED = "관련 %s 퀘스트:",
        COMPLETED = "완료된",

        QUEST_LABEL = "퀘스트:",
        NEEDS = "(%d개 필요)",

        QUESTIE_NOT_LOADED = "QuestieDB가 로드되지 않았습니다. QuestieDB를 활성화하고 UI를 다시 불러오세요.",
        API_INCOMPATIBLE = "QuestieDB API가 호환되지 않습니다.",
        LOADED = "로드됨. 퀘스트 관련 아이템 위에 마우스를 올리거나 /qil scan을 사용하세요.",

        SCAN_KEEP = "보관 %s — %d/%d, %d개 더 필요 — %s",
        SCAN_EXCESS = "여분 %s — %d개 보유, %d개 필요; %d개 버릴 수 있음 — %s",
        SCAN_STARTS = "보관 %s — %s 시작",
        SCAN_CHECK = "확인 %s — 완료되지 않은 퀘스트와 연결됨: %s",
        SCAN_ACTIVE_SUPPORT = "보관 %s — 진행 중인 퀘스트 원천 아이템 — %s",
        SCAN_LIKELY_SAFE = "삭제해도 안전할 가능성 높음 %s — 완료되지 않은 퀘스트 중 이 아이템이 필요한 퀘스트가 없음",
        SCAN_UNKNOWN = "알 수 없음 %s — WoW가 퀘스트 아이템으로 표시하지만 퀘스트 매핑이 없음",
        SCAN_NONE = "QuestieDB가 가방에서 퀘스트 관련 아이템을 찾지 못했습니다.",
        ACTIVE_QUEST = "진행 중인 퀘스트",

        COMMANDS = "명령어: /qil scan, /qil refresh",
        REFRESHED = "퀘스트 데이터베이스 색인과 진행 중인 퀘스트 캐시를 새로고침했습니다.",

        UNKNOWN_QUEST = "알 수 없는 퀘스트",
        QUEST_N = "퀘스트 %d",
    },

    zhCN = {
        STATUS_KEEP = "保留",
        STATUS_EXCESS = "有富余",
        STATUS_KEEP_FOR_NOW = "暂时保留",
        STATUS_POSSIBLE_FUTURE = "可能有任务用途",
        STATUS_UNKNOWN = "任务用途未知",
        STATUS_LIKELY_SAFE = "很可能可以安全删除",

        ACROSS_BAGS_REQUIRED = "所有背包合计：%d / %d 需要",
        STILL_NEED = "还缺 %d 个。",
        EXACT_AMOUNT = "数量刚好；请勿丢弃。",
        ACROSS_BAGS_OWNED = "所有背包合计：%d 个持有，%d 个需要",
        UP_TO_DISCARD = "最多可丢弃 %d 个。",

        SOURCE_ITEM_ACTIVE = "QuestieDB 将其标记为某%s任务的来源物品。",
        ACTIVE = "进行中的",

        STARTS_UNFINISHED = "开启一个未完成的任务：",

        POSSIBLE_FUTURE_LINE1 = "当前任务不需要，但 QuestieDB 将其",
        POSSIBLE_FUTURE_LINE2 = "关联到未完成的任务。请勿自动删除。",

        UNKNOWN_LINE1 = "WoW 将其标记为任务物品，但其任务不在",
        UNKNOWN_LINE2 = "可用的任务数据库或你当前的任务日志中。",
        UNKNOWN_LINE3 = "除非你确定任务已完成，否则请保留。",

        LIKELY_SAFE_LINE = "没有未完成的任务需要此物品。",
        RELATED_COMPLETED = "相关%s任务：",
        COMPLETED = "已完成的",

        QUEST_LABEL = "任务：",
        NEEDS = "（需要 %d 个）",

        QUESTIE_NOT_LOADED = "QuestieDB 未加载。请启用 QuestieDB 并重新加载界面。",
        API_INCOMPATIBLE = "QuestieDB API 不兼容。",
        LOADED = "已加载。将鼠标悬停在任务物品上，或使用 /qil scan。",

        SCAN_KEEP = "保留 %s — %d/%d，还缺 %d 个 — %s",
        SCAN_EXCESS = "富余 %s — %d 个持有，%d 个需要；可丢弃 %d 个 — %s",
        SCAN_STARTS = "保留 %s — 开启 %s",
        SCAN_CHECK = "检查 %s — 关联未完成任务：%s",
        SCAN_ACTIVE_SUPPORT = "保留 %s — 进行中任务的来源物品 — %s",
        SCAN_LIKELY_SAFE = "很可能可以安全删除 %s — 没有未完成的任务需要此物品",
        SCAN_UNKNOWN = "未知 %s — WoW 标记为任务物品，但无任务映射",
        SCAN_NONE = "QuestieDB 未在背包中找到任务相关物品。",
        ACTIVE_QUEST = "进行中的任务",

        COMMANDS = "命令：/qil scan, /qil refresh",
        REFRESHED = "任务数据库索引和进行中任务缓存已刷新。",

        UNKNOWN_QUEST = "未知任务",
        QUEST_N = "任务 %d",
    },

    zhTW = {
        STATUS_KEEP = "保留",
        STATUS_EXCESS = "有多餘",
        STATUS_KEEP_FOR_NOW = "暫時保留",
        STATUS_POSSIBLE_FUTURE = "可能有任務用途",
        STATUS_UNKNOWN = "任務用途未知",
        STATUS_LIKELY_SAFE = "很可能可以安全刪除",

        ACROSS_BAGS_REQUIRED = "所有背包合計：%d / %d 需要",
        STILL_NEED = "還缺 %d 個。",
        EXACT_AMOUNT = "數量剛好；請勿丟棄。",
        ACROSS_BAGS_OWNED = "所有背包合計：%d 個持有，%d 個需要",
        UP_TO_DISCARD = "最多可丟棄 %d 個。",

        SOURCE_ITEM_ACTIVE = "QuestieDB 將其標記為某%s任務的來源物品。",
        ACTIVE = "進行中的",

        STARTS_UNFINISHED = "開啟一個未完成的任務：",

        POSSIBLE_FUTURE_LINE1 = "目前任務不需要，但 QuestieDB 將其",
        POSSIBLE_FUTURE_LINE2 = "關聯到未完成的任務。請勿自動刪除。",

        UNKNOWN_LINE1 = "WoW 將其標記為任務物品，但其任務不在",
        UNKNOWN_LINE2 = "可用的任務資料庫或你目前的任務日誌中。",
        UNKNOWN_LINE3 = "除非你確定任務已完成，否則請保留。",

        LIKELY_SAFE_LINE = "沒有未完成的任務需要此物品。",
        RELATED_COMPLETED = "相關%s任務：",
        COMPLETED = "已完成的",

        QUEST_LABEL = "任務：",
        NEEDS = "（需要 %d 個）",

        QUESTIE_NOT_LOADED = "QuestieDB 未載入。請啟用 QuestieDB 並重新載入介面。",
        API_INCOMPATIBLE = "QuestieDB API 不相容。",
        LOADED = "已載入。將滑鼠移到任務物品上，或使用 /qil scan。",

        SCAN_KEEP = "保留 %s — %d/%d，還缺 %d 個 — %s",
        SCAN_EXCESS = "多餘 %s — %d 個持有，%d 個需要；可丟棄 %d 個 — %s",
        SCAN_STARTS = "保留 %s — 開啟 %s",
        SCAN_CHECK = "檢查 %s — 關聯未完成任務：%s",
        SCAN_ACTIVE_SUPPORT = "保留 %s — 進行中任務的來源物品 — %s",
        SCAN_LIKELY_SAFE = "很可能可以安全刪除 %s — 沒有未完成的任務需要此物品",
        SCAN_UNKNOWN = "未知 %s — WoW 標記為任務物品，但無任務映射",
        SCAN_NONE = "QuestieDB 未在背包中找到任務相關物品。",
        ACTIVE_QUEST = "進行中的任務",

        COMMANDS = "指令：/qil scan, /qil refresh",
        REFRESHED = "任務資料庫索引和進行中任務快取已重新整理。",

        UNKNOWN_QUEST = "未知任務",
        QUEST_N = "任務 %d",
    },
}

local locale = GetLocale() or "enUS"
local override = localized[locale]
if override then
    for k, v in pairs(override) do
        L[k] = v
    end
end

ns.L = L
