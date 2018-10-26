unit EcranTribu;

interface

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher();



implementation

  uses Variables, GestionEcran, OptnAffichage, EcranAccueil, EcranElevage, EcranMilitaire;


  { Actions effectuées lors d'un passage au tour suivant }
  procedure tourSuivant;
  begin
    { On passe au jour suivant }
    setTribu_numJour(getTribu().numJour + 1);

    { Calcul du savoir/j à partir du savoir/j absolu }
    setElevage_savoirJour(getElevage().savoirJourAbsolu - getElevage().population);
    { Augmentation du savoir acquis (croissance) }
    setElevage_savoirAcquis(getElevage().savoirAcquis + getElevage().savoirJour);

    { Les points de recrutement sont rechargés }
    setTribu_ptsRecrutement(getTribu().ptsRecrutementJour);

    { Si une construction est en cours, on augmente le total d'équations résolues (travail) }
    if getElevage().construction = True then setElevage_equationsResolues( getElevage().equationsResolues
                                                                         + getElevage().equationsJour);

    { Vérification des états d'avancement de la croissance et de la construction }
    majConstruction();
    majCroissance();

    { Enfin, on affiche de nouveau l'écran }
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

    if (choix = '1') then
    begin
      EcranElevage.afficher();
    end;

    if (choix = '2') then
    begin
      EcranMilitaire.afficher();
    end;

    if (choix = '9') then tourSuivant();

    if (choix = '0') then
    begin
      EcranAccueil.verifQuitter();
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
    afficherTitre('ECRAN DE GESTION DE LA TRIBU', 6);

    { Corps de l'écran }
    deplacerCurseurXY(3,10);
    writeln('Liste des Élevages :');
    deplacerCurseurXY(3,11);
    writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');
    afficherElevage(4,13);

    { Choix disponibles }
    deplacerCurseurXY(3,22);
    writeln('1 - Gérer l''Élevage : ', getElevage().nom);
    deplacerCurseurXY(3,23);
    writeln('2 - Gestion militaire et diplomatique');
    deplacerCurseurXY(3,25);
    writeln('9 - Fin de tour');
    deplacerCurseurXY(3,26);
    writeln('0 - Quitter la partie');

    { Partie inférieure de l'écran }
    afficherMessage();
    afficherCadreAction();

    choisir();
  end;

end.
