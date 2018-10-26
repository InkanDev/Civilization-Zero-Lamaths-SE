unit EcranMilitaire;

interface

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher;



implementation

  uses Variables, GestionEcran, OptnAffichage, EcranTribu, EcranCombat;


  { Dépense des points de recrutement pour acheter un Lama (soldat) }
  procedure recruterLama;
  begin
    if getEnclos().niveau >= 1 then
    begin
      if getTribu().ptsRecrutement >= getLama().prix then
      begin
        setTribu_ptsRecrutement(getTribu().ptsRecrutement - getLama().prix);
        setLama_nb(getLama().nb + 1);
      end
      else setMessage('Pas assez de points de recrutement');
    end
    else setMessage('Enclos non construit');
  end;

  { Dépense des points de recrutement pour acheter un Alpaga (canon) }
  procedure recruterAlpaga;
  begin
    if getEnclos().niveau >= 1 then
    begin
      if getCDR().niveau >= 1 then
      begin
        if getTribu().ptsRecrutement >= getAlpaga().prix then
        begin
        setTribu_ptsRecrutement(getTribu().ptsRecrutement - getAlpaga().prix);
        setAlpaga_nb(getAlpaga().nb + 1);
        end
        else setMessage('Pas assez de points de recrutement');
      end
      else setMessage('Centre de recherches niv.1 requis');
    end
    else setMessage('Enclos non construit');
  end;


  { Détermine l'action à effectuer en fonction du choix de l'utilisateur }
  procedure choisir;

  var
    choix : String; // Valeur entrée par la joueur

  begin
    { Déplace le curseur dans le cadre "Action" }
    deplacerCurseurXY(114,26);
    readln(choix);

    { Liste des choix disponibles }

    if (choix = '1') then
    begin
      recruterLama();
      afficher();
    end;

    if (choix = '2') then
    begin
      recruterAlpaga();
      afficher();
    end;

    if (choix = '4') OR (choix = '5') then
    begin
      if (getLama().nb > 0) OR (getAlpaga().nb > 0) then
      begin
        if (choix = '4') then EcranCombat.genererEnnemis('petit');
        if (choix = '5') then EcranCombat.genererEnnemis('grand');
        EcranCombat.afficher();
      end
      else setMessage('Impossible d''attaquer sans armée');
      afficher();
    end;

    if (choix = '0') then
    begin
      ecranTribu.afficher();
    end

    { Valeur saisie invalide }
    else
    begin
      setMessage('Action non reconnue');
      afficher();
    end;
  end;

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher;

  begin
    effacerEcran();

    { Partie supérieure de l'écran }
    afficherEnTete();
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('ECRAN DE GESTION MILITAIRE ET DIPLOMATIQUE', 6);

    { Corps de l'écran }
    deplacerCurseurXY(3,10);
    writeln('Liste des troupes disponibles :');
    deplacerCurseurXY(3,11);
    writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');

    // Lamas disponibles
    deplacerCurseurXY(5,12);
    writeln('    Lamas :');
    if getLama().nb = 0 then couleurTexte(8)
    else couleurtexte(10);
    deplacerCurseurXY(17,12);
    writeln(getLama().nb);
    couleurTexte(15);

    // Alpagas disponibles
    deplacerCurseurXY(5,13);
    writeln('  Alpagas :');
    if getAlpaga().nb = 0 then couleurTexte(8)
    else couleurtexte(10);
    deplacerCurseurXY(17,13);
    writeln(getAlpaga().nb);
    couleurTexte(15);

    // Points de recrutement
    deplacerCurseurXY(4,16);
    if getTribu().ptsRecrutement = 0 then couleurtexte(12)
    else couleurTexte(10);
    writeln(getTribu().ptsRecrutement);
    couleurTexte(15);
    deplacerCurseurXY(6, 16);
    writeln(' points de recrutement disponibles');

    { Choix disponibles }
    deplacerCurseurXY(3,20);
    writeln('1 - Recruter un Lama');
    deplacerCurseurXY(3,21);
    writeln('2 - Recruter un Alpaga');
    deplacerCurseurXY(3,23);
    writeln('4 - Attaquer un petit pâturage de littéraires');
    deplacerCurseurXY(3,24);
    writeln('5 - Attaquer un grand pâturage de littéraires');
    deplacerCurseurXY(3,26);
    writeln('0 - Retour au menu');

    { Partie inférieure de l'écran }
    afficherMessage();
    afficherCadreAction();

    choisir();
  end;

end.
