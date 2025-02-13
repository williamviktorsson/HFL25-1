# Vad har jag gjort här?

### Detta projekt motsvarar en utökning av den färdiga första uppgiften med följande delmål:

- Sätt upp Shelf-servern med grundläggande routing.
- Implementera route-hanterare på servern och koppla dem till de befintliga repositories från uppgift 1.
- Uppdatera klientsidans repositories för att använda HTTP-anrop.
- Utöka modellklasser till att stödja serialisering/deserialisering till/från JSON.
- Modifiera CLI-gränssnittet för att hantera asynkrona operationer.
- Implementera felhantering på både klient- och serversidan.
- Testa hela systemet för att säkerställa korrekt klient-server-kommunikation.

### Vidare har jag placerat kod som delas mellan respektive projekt i cli_shared och importerat dem som dependency i både CLI och server så att jag slipper duplicerad kod.