unit EcranCombat;

interface

  uses GestionEcran, OptnAffichage, Variables;

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher;

  { Génère un nombre aléatoire de troupes ennemis en fonction de la taille indiquée }
  procedure genererEnnemis(taille : String); // 'petit' ou 'grand'



implementation

  uses EcranMilitaire;

  var

    LamaEnnemi   : TUnite; // Unité LAMA (Soldat) ennemie
    AlpagaEnnemi : TUnite; // Unité ALPAGA (Canon) ennemie

    nomEnnemi        : String;  // Nom de l'opposant
    messageCombat    : Boolean; // Le message de déroulement du combat est-il affiché ?

    unite            : String;  // Unité ennemie attaquée pendant le tour
    uniteEnnemi      : String;  // Unité alliée attaquée pendant le tour
    nbElim           : Integer; // Nombre de troupes ennemies éliminées pendant le tour
    nbElimEnnemi     : Integer; // Nombre de troupes allées éliminées pendant le tour



  { Initialisation de la TUnite LamaEnnemi }
  procedure initLamaEnnemi;
  begin
    with LamaEnnemi do
    begin
      nom        := 'Lama';
      nb         := 0;
      ptsAttaque := 1;
      prix       := 1;
    end;
  end;

  { Initialisation de la TUnite AlpagaEnnemi }
  procedure initAlpagaEnnemi;
  begin
    with AlpagaEnnemi do
    begin
      nom        := 'Alpaga';
      nb         := 0;
      ptsAttaque := 2;
      prix       := 2;
    end;
  end;



  { Génère un nombre aléatoire d'unités ennemies en fonction de la taille indiquée (petit, grand) }
  procedure genererEnnemis(taille : String);
  begin

    { (ré)Initialisation des troupes ennemies }
    initLamaEnnemi();
    initAlpagaEnnemi();

    Randomize;

    // Dans le cas d'un PETIT groupe d'ennemis
    if taille = 'petit' then
    begin
      nomEnnemi        := 'petit pâturage de littéraires';
      LamaEnnemi.nb    := 1 + Random(20);
      AlpagaEnnemi.nb  := 1 + Random(10);
    end;

    // Dans le cas d'un GRAND groupe d'ennemis
    if taille = 'grand' then
    begin
      nomEnnemi        := 'grand pâturage de littéraires';
      LamaEnnemi.nb    := 70 + Random(70);
      AlpagaEnnemi.nb  := 30 + Random(30);
    end;

  end;

  { Lance une attaque contre l'unité indiquée (Lamas, Alpagas) }
  procedure attaquer(troupe : String);

  var
    scoreAttaque       : Integer; // Score d'attaque du joueur
    scoreAttaqueEnnemi : Integer; // Score d'attaque de l'ordinateur

  begin

    // Calcul du score d'attaque du joueur}
    scoreAttaque := ( getLama().nb   * getLama().ptsAttaque )
                  + ( getAlpaga().nb * getAlpaga().ptsAttaque );

    // Calcul du score d'attaque de l'ordinateur }
    scoreAttaqueEnnemi := ( LamaEnnemi.nb   * LamaEnnemi.ptsAttaque )
                        + ( AlpagaEnnemi.nb * AlpagaEnnemi.ptsAttaque );


    { Tour de jeu : JOUEUR }

      // Calcul du nb d'unités ennemies réellement éliminées
      nbElim := random(scoreAttaque);

      // Cas dans lequel les LAMAS (Soldats) ennemis sont attaqués
      if (troupe = 'Lamas') then
      begin
        unite := 'Lamas';
        if nbElim > LamaEnnemi.nb then nbElim := LamaEnnemi.nb;
        LamaEnnemi.nb := LamaEnnemi.nb - nbElim;
        if LamaEnnemi.nb < 0 then LamaEnnemi.nb := 0;
      end;

      // Cas dans lequel les ALPAGAS (Canons) ennemis sont attaqués
      if (troupe = 'Alpagas') then
      begin
        unite := 'Alpagas';
        if nbElim > AlpagaEnnemi.nb then nbElim := AlpagaEnnemi.nb;
        AlpagaEnnemi.nb := AlpagaEnnemi.nb - nbElim;
        if AlpagaEnnemi.nb < 0 then AlpagaEnnemi.nb := 0;
      end;


    { Tour de jeu : ORDINATEUR }

      // Calcul du nb d'unités allées réellement éliminées
      nbElimEnnemi := random(scoreAttaqueEnnemi);

      { L'Ordinateur attaque en priorité les Lamas (Soldats) ; dès qu'il n'y en a plus,
        il attaque les Alpagas (Canons). }

      // Cas dans lequel les LAMAS (Soldats) alliés sont attaqués
      if getLama().nb <> 0 then
      begin
        uniteEnnemi := 'Lamas';
        if nbElimEnnemi > getLama().nb then nbElimEnnemi := getLama().nb;
        setLama_nb(getLama().nb - nbElimEnnemi);
        if getLama().nb < 0 then setLama_nb(0);
      end

      // Cas dans lequel les ALPAGAS (Canons) alliés sont attaqués
      else if getAlpaga().nb <> 0 then
      begin
        uniteEnnemi := 'Alpagas';
        if nbElimEnnemi > getAlpaga().nb then nbElimEnnemi := getAlpaga().nb;
        setAlpaga_nb(getAlpaga().nb - nbElimEnnemi);
        if getAlpaga().nb < 0 then setAlpaga_nb(0);
      end;


    messageCombat := True;
    afficher();
  end;



  { Récupère le choix du joueur et détermine l'action à effectuer }
  procedure choisir;

  var
    choix : String; // Valeur entrée par la joueur

  begin
    { Déplace le curseur dans le cadre "Action" }
    deplacerCurseurXY(114,26);
    readln(choix);

    { Liste des choix disponibles }
    if (choix = '1') then attaquer('Lamas');
    if (choix = '2') then attaquer('Alpagas')

    { Valeur saisie invalide }
    else
    begin
      setMessage('Action non reconnue');
      afficher();
    end;
  end;

  { Affiche l'écran de victoire }
  procedure victoire;

  var // Coordonnées auxquelles est affiché le message "Victoire"
    x : Integer;
    y : Integer;

  begin
    x := 55;
    y := 15;

    effacerEcran();

    // Affichage de l'en-tête
    afficherEnTete();

    // Dessin du cadre principal et affichage du titre de l'écran
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('COMBAT CONTRE : ' + nomEnnemi , 6);

    // Affichage du message "Victoire"
    dessinerCadreXY(x-3,y-1, x+10,y+1, double, 15,0);
    deplacerCurseurXY(x,y);
    couleurTexte(10);
    writeln('VICTOIRE');
    couleurTexte(15);

    // Le message du déroulement du combat n'est plus affiché
    messageCombat := False;

    // Le joueur appuie sur ENTRER et est renvoyé à l'écran de gestion Militaire et Diplomatique
    afficherCadreAction();
    deplacerCurseurXY(114,26);
    readln;
    EcranMilitaire.afficher();
  end;

  { Affiche l'écran de défaite }
  procedure defaite;

  var // Coordonnées auxquelles est affiché le message "défaite"
    x : Integer;
    y : Integer;

  begin
    x := 56;
    y := 15;

    effacerEcran();

    // Affichage de l'en-tête
    afficherEnTete();

    // Dessin du cadre principal et affichage du titre de l'écran
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('COMBAT CONTRE : ' + nomEnnemi , 6);

    // Affichage du message "Défaite"
    dessinerCadreXY(x-3,y-1, x+9,y+1, double, 15,0);
    deplacerCurseurXY(x,y);
    couleurTexte(12);
    writeln('DEFAITE');
    couleurTexte(15);

    // Le message du déroulement du combat n'est plus affiché
    messageCombat := False;

    // Le joueur appuie sur ENTRER et est renvoyé à l'écran de gestion Militaire et Diplomatique
    afficherCadreAction();
    deplacerCurseurXY(114,26);
    readln;
    EcranMilitaire.afficher();
  end;

  { Affiche un message résumant le déroulement du combat si messageCombat = True }
  procedure afficherCombat;
  begin
    { Cadre du message }
    dessinerCadreXY(58,14, 109,19, simple, 15,0);
    deplacerCurseurXY(60,14);
    writeln(' Champ de bataille ');

    { Si le combat a commencé }
    if messageCombat = True then
    begin
      // Bilan de l'attaque du Joueur
      deplacerCurseurXY(62,16);
      if nbElim > 0 then couleurTexte(10)
      else couleurTexte(8);
      writeln('Vos troupes crachent sur ', nbElim, ' ', unite, ' ennemis.');

      // Bilan de l'attaque de l'Ordinateur
      deplacerCurseurXY(62,17);
      if nbElimEnnemi > 0 then couleurTexte(12)
      else couleurTexte(8);
      writeln('L''ennemi crache sur ', nbElimEnnemi, ' de vos ', uniteEnnemi, '.');
      couleurTexte(15);
    end

    else
    begin
      deplacerCurseurXY(62,16);
      writeln('Préparez-vous au combat !');
    end;
  end;

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher();

  begin
    { On vérifie d'abord si l'un des deux belligérants a remporté le combat,
      auquel cas on affiche l'écran de Victoire/Défaite. }
    if (LamaEnnemi.nb = 0) AND (AlpagaEnnemi.nb = 0) then victoire();
    if (getLama().nb = 0) AND (getAlpaga().nb = 0) then defaite();

    effacerEcran();

    { Partie supérieure de l'écran }
    afficherEnTete();
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('COMBAT CONTRE : ' + nomEnnemi , 6);

    { Corps de l'écran }

      // Armée du Joueur
        deplacerCurseurXY(3,10);
        writeln('Descriptif de vos forces :');
        deplacerCurseurXY(3,11);
        writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');

        // Lamas
        deplacerCurseurXY(5,12);
        writeln('    Lamas : ');
        if getLama().nb = 0 then couleurTexte(8)
        else couleurtexte(10);
        deplacerCurseurXY(17,12);
        writeln(getLama().nb);
        couleurTexte(15);

        // Alpagas
        deplacerCurseurXY(5,13);
        writeln('  Alpagas : ');
        if getAlpaga().nb = 0 then couleurTexte(8)
        else couleurtexte(10);
        deplacerCurseurXY(17,13);
        writeln(getAlpaga().nb);
        couleurTexte(15);


      // Armée ennemie
        deplacerCurseurXY(3,16);
        writeln('Descriptif des forces ennemies :');
        deplacerCurseurXY(3,17);
        writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');

        // Lamas ennemis
        deplacerCurseurXY(5,18);
        writeln('    Lamas : ');
        if LamaEnnemi.nb = 0 then couleurTexte(8)
        else couleurtexte(12);
        deplacerCurseurXY(17,18);
        writeln(LamaEnnemi.nb);
        couleurTexte(15);

        // Alpagas ennemis
        deplacerCurseurXY(5,19);
        writeln('  Alpagas : ');
        if AlpagaEnnemi.nb = 0 then couleurTexte(8)
        else couleurtexte(12);
        deplacerCurseurXY(17,19);
        writeln(AlpagaEnnemi.nb);
        couleurTexte(15);


    // Affichage du déroulement du combat
    afficherCombat();

    { Choix disponibles }
    deplacerCurseurXY(3,25);
    writeln('1 - Cracher sur les ', LamaEnnemi.nom, ' ennemis');
    deplacerCurseurXY(3,26);
    writeln('2 - Cracher sur les ', AlpagaEnnemi.nom, ' ennemis');

    { Partie inférieure de l'écran }
    afficherMessage();
    afficherCadreAction();

    choisir();
  end;

end.
