unit EcranTribu;

interface

  { Affichage de l'�cran et appel des fonctions & proc�dures associ�es }
  procedure afficher();



implementation

  uses Variables, GestionEcran, OptnAffichage, EcranAccueil, EcranElevage, EcranMilitaire;


  { Actions effectu�es lors d'un passage au tour suivant }
  procedure tourSuivant;
  begin
    { On passe au jour suivant }
    setTribu_numJour(getTribu().numJour + 1);

    { Calcul du savoir/j � partir du savoir/j absolu }
    setElevage_savoirJour(getElevage().savoirJourAbsolu - getElevage().population);
    { Augmentation du savoir acquis (croissance) }
    setElevage_savoirAcquis(getElevage().savoirAcquis + getElevage().savoirJour);

    { Les points de recrutement sont recharg�s }
    setTribu_ptsRecrutement(getTribu().ptsRecrutementJour);

    { Si une construction est en cours, on augmente le total d'�quations r�solues (travail) }
    if getElevage().construction = True then setElevage_equationsResolues( getElevage().equationsResolues
                                                                         + getElevage().equationsJour);

    { V�rification des �tats d'avancement de la croissance et de la construction }
    majConstruction();
    majCroissance();

    { Enfin, on affiche de nouveau l'�cran }
    afficher();
  end;


  { R�cup�re le choix du joueur et d�termine l'action � effectuer }
  procedure choisir;

  var
    choix : String; // Valeur entr�e par la joueur

  begin
    { D�place le curseur dans le cadre "Action" }
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

  { Affichage de l'�cran et appel des fonctions & proc�dures associ�es }
  procedure afficher;

  begin
    effacerEcran();

    { Partie sup�rieure de l'�cran }
    afficherEnTete();
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('ECRAN DE GESTION DE LA TRIBU', 6);

    { Corps de l'�cran }
    deplacerCurseurXY(3,10);
    writeln('Liste des �levages :');
    deplacerCurseurXY(3,11);
    writeln('��������������������');
    afficherElevage(4,13);

    { Choix disponibles }
    deplacerCurseurXY(3,22);
    writeln('1 - G�rer l''�levage : ', getElevage().nom);
    deplacerCurseurXY(3,23);
    writeln('2 - Gestion militaire et diplomatique');
    deplacerCurseurXY(3,25);
    writeln('9 - Fin de tour');
    deplacerCurseurXY(3,26);
    writeln('0 - Quitter la partie');

    { Partie inf�rieure de l'�cran }
    afficherMessage();
    afficherCadreAction();

    choisir();
  end;

end.
