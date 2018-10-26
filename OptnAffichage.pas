unit OptnAffichage;

interface

  { Affiche l'en-tête contenant le nom de la Tribu et le numéro du Jour }
  procedure afficherEnTete;

  { Affiche le cadre "Action" dans lequel le Joueur saisit l'action à effectuer }
  procedure afficherCadreAction;

  { Automatise l'affichage du titre d'un écran entré en paramètre }
  procedure afficherTitre(titre : String; y  : Integer);

  { Affiche un éventuel message à gauche du cadre "Action" }
  procedure afficherMessage;
  { Indique le message à afficher lors de l'appel de la procédure afficherMessage }
  procedure setMessage(valeur : String);

  { Affiche un résumé de l'état de la ville aux coordonnées (x,y) }
  procedure afficherElevage(x,y : Integer);



implementation

  uses Variables, GestionEcran;

  var
    message : String; // Variable contenant le message à afficher à gauche du cadre "Action"
                      // Ex : 'Action non reconnue' ou 'Construction lancée'


  { Affiche l'en-tête contenant le nom de la Tribu et le numéro du Jour }
  procedure afficherEnTete;
  begin
    dessinerCadreXY(0,0, 119,4, simple, 15,0);

    // Nom de la Tribu
    deplacerCurseurXY(3,2);
    writeln('Tribu : ');
    deplacerCurseurXY(3+LENGTH('Tribu : '),2);
    couleurTexte(11);
    writeln(getTribu().nom);
    couleurTexte(15);

    // Numéro du Jour
    dessinerCadreXY(103,1, 117,3, simple, 15,0);
    deplacerCurseurXY(105,2);
    writeln('Jour : ', getTribu().numJour);
  end;

  { Automatise l'affichage du titre d'un écran }
  procedure afficherTitre(titre : String; y  : Integer);
  begin
    // Création du cadre
    if ((length(titre) mod 2) = 0) then
    begin
      dessinerCadreXY( (58 - (length(titre) div 2) - 2), (y-1), (58 + (length(titre) div 2) + 3), (y+1), double, 15, 0);
    end
    else dessinerCadreXY( (58 - (length(titre) div 2) - 2), (y-1), (58 + (length(titre) div 2) + 4), (y+1), double, 15, 0);

    // Ecriture du titre
    deplacerCurseurXY( (58 - (length(titre) div 2) + 1), y);
    writeln(titre);
  end;


  { Affiche le cadre "Action" dans lequel le Joueur saisit l'action à effectuer }
  procedure afficherCadreAction;

  var // Coordonnées auxquelles est affiché le cadre
    x : Integer;
    y : Integer;

  begin
    x := 105;
    y := 26;

    dessinerCadreXY((x-2),(y-1), (x+12),(y+1), Simple, 15,0);
    deplacerCurseurXY(x,y);
    writeln('Action : ');
  end;

  { Automatise l'affichage d'une action qu'il est possible d'effectuer }
  procedure afficherAction(x,y : Integer; numero, action, couleur : String);
  begin
    // Ecriture du crochet gauche
    deplacerCurseurXY(x,y);
    writeln('[');

    // Ecriture du numéro de l'action
    if couleur = 'vert' then couleurTexte(10)
    else if couleur = 'cyan' then couleurTexte(11)
    else if couleur = 'rouge' then couleurTexte(12)
    else if couleur = 'magenta' then couleurTexte(13)
    else if couleur = 'jaune' then couleurTexte(14);
    deplacerCurseurXY(x+1,y);
    writeln(numero);
    couleurTexte(15);

    // Ecriture du crochet droit
    deplacerCurseurXY(x+1+length(numero),y);
    writeln(']');

    // Ecriture de l'intitulé de l'action
    deplacerCurseurXY(x+3+length(numero),y);
    writeln(action);
  end;


  { Affiche un éventuel message à gauche du cadre "Action" }
  procedure afficherMessage;
  begin

    { Si la variable message n'est pas vide (''), c'est-à-dire qu'un message a été envoyé
      suite à une action, ce message est affiché à gauche du cadre "Action".
      Après son affichage, le message est réinitialisé à ''. }

    if (message <> '') then
      deplacerCurseurXY(101 - length(message),26); // Calcul automatique de l'origine en fonction
      writeln(message);                            // de la taille du message.
      message := ''; // Réinitialisation
  end;

  { Indique le message à afficher lors de l'appel de la procédure afficherMessage }
  procedure setMessage(valeur : String);
  begin
    message := valeur;
  end;


  { Affiche l'état de la construction en cours aux coordonnées (x,y) }
  procedure afficherConstruction(x,y : Integer);

  var
    batiment : String;  // Nom du bâtiment en construction
    niveau   : Integer; // Niveau vers lequel le bâtiment est amélioré
    palier   : Integer; // Travail nécessaire pour achever la construction
    compteurNiveau : Integer; // Compteur

  begin
    // Dans tous les cas, on affiche le travail ajouté par tour
    deplacerCurseurXY(x,y);
    writeln('Équations par jour : ');
    deplacerCurseurXY(x+length('Équations par jour : '),y);
    couleurTexte(10);
    writeln(getElevage().equationsJour);
    couleurTexte(15);

    { Si une construction est en cours, l'affichage de son état nécessite d'identifier le nom du bâtiment
      en construction, le niveau vers lequel ce bâtiment est amélioré, et le total d'équations à résoudre (palier)
      pour en achever la construction. Les instructions suivantes ont pour but d'identifier ces valeurs. }

    // Dans le cas où une construction est en cours
    if getElevage().construction = True then
    begin

      // Université
      if getUniversite().construction = True then
      begin
        batiment := getUniversite().nom;
        niveau   := getUniversite().niveau + 1;
        palier   := getUniversite().PALIERS[niveau];
      end;

      // Centre de recherches
      if getCDR().construction = True then
      begin
        batiment := getCDR().nom;
        niveau   := getCDR().niveau + 1;
        palier   := getCDR().PALIERS[niveau];
      end;

      // Laboratoire
      if getLaboratoire().construction = True then
      begin
        batiment := getLaboratoire().nom;
        niveau   := getLaboratoire().niveau + 1;
        palier   := getLaboratoire().PALIERS[niveau];
      end;

      // Enclos
      if getEnclos().construction = True then
      begin
        batiment := getEnclos().nom;
        niveau   := getEnclos().niveau + 1;
        palier   := getEnclos().PALIERS[niveau];
      end;


      { A partir des valeurs identifiées, on affiche le nom du bâtiment en construction
        et le niveau vers lequel il est amélioré ainsi que le total d'équations résolues
        et le nombre d'équations à résoudre pour en achever la construction. }

      deplacerCurseurXY(x,y+1);
      writeln('Construction : ', batiment, ' niveau ', niveau);
      deplacerCurseurXY(x,y+2);
      writeln('Équations résolues : ', getElevage().equationsResolues, '/', palier);
    end

    // Dans le cas où aucune construction n'est en cours
    else
    begin
      deplacerCurseurXY(x,y+1);
      couleurTexte(8);
      writeln('Pas de construction en cours');
      couleurTexte(15);
    end;
  end;

  { Affiche l'état de la croissance de l'Elevage aux coordonnées (x,y) }
  procedure afficherCroissance(x,y : Integer);
  begin
    // Dans tous les cas, on affiche le seuil de Savoir à acquir pour croître
    deplacerCurseurXY(x,y);
    writeln('Savoir acquis : ', getElevage().savoirAcquis, '/', getElevage().seuilCroissance);

    { S'il y a croissance, on affiche le savoir ajouté à chaque jour et le nombre
      de jours restant avant la croissance (gain de population) de l'élevage. }
    if getElevage().savoirJour > 0 then
    begin
      deplacerCurseurXY(x,y+1);
      writeln('Savoir par jour : ', getElevage().savoirJour);
      deplacerCurseurXY(x,y+2);
      writeln('Nb jours avant croissance : ', getElevage().nbJourAvCroissance)
    end

    // S'il n'y aucune croissance, on le signale
    else
    begin
      deplacerCurseurXY(x,y+1);
      couleurTexte(8);
      writeln('Aucune croissance');
      couleurTexte(15);
    end;
  end;

  { Affiche un cadre résumant l'état de l'Elevage aux coordonnées (x,y) }
  procedure afficherElevage(x,y : Integer);

  begin
    // Dessin du cadre
    dessinerCadreXY(2,y-1, 117,y+3, simple, 15,0);

    // Affichage du nom de l'élevage
    deplacerCurseurXY(x,y);
    writeln('Nom : ');
    deplacerCurseurXY(x+6,y);
    couleurTexte(11);
    writeln(getElevage().nom);
    couleurtexte(15);

    // Affichage de sa population
    deplacerCurseurXY(x,y+1);
    writeln('Population : ', getElevage().population);

    // Affichage de l'état de sa croissance
    afficherCroissance(x+30,y);

    // Affichage de l'état de la construction en cours
    afficherConstruction(x+68,y);
  end;

end.
