# imnabbo

## TODO:

- [ ] Aggiungere utilizzi rimanenti carte
  
  - idea:
    - aggiungere utilizzi rimanenti nel json
    - inserire pulsanti +/- sotto la carta
    - se `utilizzi == -1`, allora infiniti (mappabile come U(nlimited) nel Json)

- [ ] Aggiungere rarità massima: codificare come 7 (?) una rarità massima e poi fare dei calcoli per le varie rarità (magari con un mapping invece del `%6+1`), magari se rarità massima mettere una visuale diversa (stelline verdi), se pescata rarità massima, riprodurre un altro suono

- Modificare draw prob delle carte: attuale: pesca una rarità random, se non ci sono carte in quella rarità controlla nelle rarità più basse, se non ci sono carte nelle rarità più basse controlla in quelle più alte, se non trova nulla, semplicemente pesca la prima carta della lista (messo per non far esplodere il programma), dimmi se vuoi che faccio il check al contrario (quindi se esce la rarità 4 stelle ma non ci sono carte, provo prima a pescare dalle 5 e poi 6 facendo 5-6-3-2-1 invece di 3-2-1-5-6). In questo modo, la probabilità delle singole carte è data semplicemente da Percentuale_rarità/numero_carte_di_quella_rarità

- Settare il colore in qualche modo: per il colore, non sono in grado di fare un color picker. Posso fare un file tipo colorRGB.txt in cui metti i tre valori RGB (es. 155, 230, 5) e li prende da lì.

- 1.5 sec apparire, 1 sec sparire, ?? sec rimanere: usare due tempi diversi per far apparire e sparire la carta rischio di spaccare tutto, quindi se posso usare lo stesso tempo sarebbe meglio. Quanto vuoi che lo faccio rimanere?

- mark A/B da attivare