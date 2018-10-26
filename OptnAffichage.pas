unit OptnAffichage;

interface

  { Affiche l'en-t�te contenant le nom de la Tribu et le num�ro du Jour }
  procedure afficherEnTete;

  { Affiche le cadre "Action" dans lequel le Joueur saisit l'action � effectuer }
  procedure afficherCadreAction;

  { Automatise l'affichage du titre d'un �cran entr� en param�tre }
  procedure afficherTitre(titre : String; y  : Integer);

  { Affiche un �ventuel message � gauche du cadre "Action" }
  procedure afficherMessage;
  { Indique le message � afficher lors de l'appel de la proc�dure afficherMessage }
  procedure setMessage(valeur : String);

  { Affiche un r�sum� de l'�tat de la ville aux coordonn�es (x,y) }
  procedure afficherElevage(x,y : Integer);



implementation

  uses Variables, GestionEcran;

  var
    message : String; // Variable contenant le message � afficher � gauche du cadre "Action"
                      // Ex : 'Action non reconnue' ou 'Construction lanc�e'


  { Affiche l'en-t�te contenant le nom de la Tribu et le num�ro du Jour }
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

    // Num�ro du Jour
    dessinerCadreXY(103,1, 117,3, simple, 15,0);
    deplacerCurseurXY(105,2);
    writeln('Jour : ', getTribu().numJour);
  end;

  { Automatise l'affichage du titre d'un �cran }
  procedure afficherTitre(titre : String; y  : Integer);
  begin
    // Cr�ation du cadre
    if ((length(titre) mod 2) = 0) then
    begin
      dessinerCadreXY( (58 - (length(titre) div 2) - 2), (y-1), (58 + (length(titre) div 2) + 3), (y+1), double, 15, 0);
    end
    else dessinerCadreXY( (58 - (length(titre) div 2) - 2), (y-1), (58 + (length(titre) div 2) + 4), (y+1), double, 15, 0);

    // Ecriture du titre
    deplacerCurseurXY( (58 - (length(titre) div 2) + 1), y);
    writeln(titre);
  end;


  { Affiche le cadre "Action" dans lequel le Joueur saisit l'action � effectuer }
  procedure afficherCadreAction;

  var // Coordonn�es auxquelles est affich� le cadre
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

    // Ecriture du num�ro de l'action
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

    // Ecriture de l'intitul� de l'action
    deplacerCurseurXY(x+3+length(numero),y);
    writeln(action);
  end;


  { Affiche un �ventuel message � gauche du cadre "Action" }
  procedure afficherMessage;
  begin

    { Si la variable message n'est pas vide (''), c'est-�-dire qu'un message a �t� envoy�
      suite � une action, ce message est affich� � gauche du cadre "Action".
      Apr�s son affichage, le message est r�initialis� � ''. }

    if (message <> '') then
      deplacerCurseurXY(101 - length(message),26); // Calcul automatique de l'origine en fonction
      writeln(message);                            // de la taille du message.
      message := ''; // R�initialisation
  end;

  { Indique le message � afficher lors de l'appel de la proc�dure afficherMessage }
  procedure setMessage(valeur : String);
  begin
    message := valeur;
  end;


  { Affiche l'�tat de la construction en cours aux coordonn�es (x,y) }
  procedure afficherConstruction(x,y : Integer);

  var
    batiment : String;  // Nom du b�timent en construction
    niveau   : Integer; // Niveau vers lequel le b�timent est am�lior�
    palier   : Integer; // Travail n�cessaire pour achever la construction
    compteurNiveau : Integer; // Compteur

  begin
    // Dans tous les cas, on affiche le travail ajout� par tour
    deplacerCurseurXY(x,y);
    writeln('�quations par jour : ');
    deplacerCurseurXY(x+length('�quations par jour : '),y);
    couleurTexte(10);
    writeln(getElevage().equationsJour);
    couleurTexte(15);

    { Si une construction est en cours, l'affichage de son �tat n�cessite d'identifier le nom du b�timent
      en construction, le niveau vers lequel ce b�timent est am�lior�, et le total d'�quations � r�soudre (palier)
      pour en achever la construction. Les instructions suivantes ont pour but d'identifier ces valeurs. }

    // Dans le cas o� une construction est en cours
    if getElevage().construction = True then
    begin

      // Universit�
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


      { A partir des valeurs identifi�es, on affiche le nom du b�timent en construction
        et le niveau vers lequel il est am�lior� ainsi que le total d'�quations r�solues
        et le nombre d'�quations � r�soudre pour en achever la construction. }

      deplacerCurseurXY(x,y+1);
      writeln('Construction : ', batiment, ' niveau ', niveau);
      deplacerCurseurXY(x,y+2);
      writeln('�quations r�solues : ', getElevage().equationsResolues, '/', palier);
    end

    // Dans le cas o� aucune construction n'est en cours
    else
    begin
      deplacerCurseurXY(x,y+1);
      couleurTexte(8);
      writeln('Pas de construction en cours');
      couleurTexte(15);
    end;
  end;

  { Affiche l'�tat de la croissance de l'Elevage aux coordonn�es (x,y) }
  procedure afficherCroissance(x,y : Integer);
  begin
    // Dans tous les cas, on affiche le seuil de Savoir � acquir pour cro�tre
    deplacerCurseurXY(x,y);
    writeln('Savoir acquis : ', getElevage().savoirAcquis, '/', getElevage().seuilCroissance);

    { S'il y a croissance, on affiche le savoir ajout� � chaque jour et le nombre
      de jours restant avant la croissance (gain de population) de l'�levage. }
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

  { Affiche un cadre r�sumant l'�tat de l'Elevage aux coordonn�es (x,y) }
  procedure afficherElevage(x,y : Integer);

  begin
    // Dessin du cadre
    dessinerCadreXY(2,y-1, 117,y+3, simple, 15,0);

    // Affichage du nom de l'�levage
    deplacerCurseurXY(x,y);
    writeln('Nom : ');
    deplacerCurseurXY(x+6,y);
    couleurTexte(11);
    writeln(getElevage().nom);
    couleurtexte(15);

    // Affichage de sa population
    deplacerCurseurXY(x,y+1);
    writeln('Population : ', getElevage().population);

    // Affichage de l'�tat de sa croissance
    afficherCroissance(x+30,y);

    // Affichage de l'�tat de la construction en cours
    afficherConstruction(x+68,y);
  end;

end.
