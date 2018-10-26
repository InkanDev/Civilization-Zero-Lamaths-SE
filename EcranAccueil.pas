unit EcranAccueil;

interface

  {Affiche l'écran d'accueil du jeu}
  procedure afficher;

  { Affiche un écran de vérification Quitter ? Oui/Non }
  procedure verifQuitter;

implementation

  uses Variables, GestionEcran, OptnAffichage, EcranTribu;

  { 2 écrans successifs permettant au joueur de nommer sa Tribu }
  procedure creerTribu;

  var
    nomTribu, nomElevage : String; // Noms saisis par le joueur

  begin
    { Création de la Tribu }
    effacerEcran();
    afficherTitre('QUEL EST LE NOM DE VOTRE TRIBU ?', 10);
    deplacerCurseurXY(48,14);
    writeln('Nom :');
    deplacerCurseurXY(55,14);
    readln(nomTribu);

    { Création de l'Elevage }
    effacerEcran();
    afficherTitre('NOM DE SON ELEVAGE PRINCIPAL', 10);
    deplacerCurseurXY(48,14);
    writeln('Nom :');
    deplacerCurseurXY(55,14);
    readln(nomElevage);

    { Affectation des noms saisis }
    setTribu_nom(nomTribu);
    setElevage_nom(nomElevage);

    { Début de la partie }
    EcranTribu.afficher();
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
      creerTribu();
    end;

    if (choix = '2') then halt

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

    { (ré)Initialisation du joueur }
    initJoueur();

    { TITRE }
    couleurTexte(15);
    deplacerCurseurXY(13,1);
    write('─────────────────────────────────────────────────────────────────────────────────────────────');
    deplacerCurseurXY(13,3);
    write(' ██████╗██╗██╗   ██╗██╗██╗     ██╗███████╗ █████╗ ████████╗██╗ ██████╗ ███╗   ██╗     ██████╗');
    deplacerCurseurXY(13,4);
    write('██╔════╝██║██║   ██║██║██║     ██║╚══███╔╝██╔══██╗╚══██╔══╝██║██╔═══██╗████╗  ██║    ██╔═████╗');
    deplacerCurseurXY(13,5);
    write('██║     ██║██║   ██║██║██║     ██║  ███╔╝ ███████║   ██║   ██║██║   ██║██╔██╗ ██║    ██║██╔██║');
    deplacerCurseurXY(13,6);
    write('██║     ██║╚██╗ ██╔╝██║██║     ██║ ███╔╝  ██╔══██║   ██║   ██║██║   ██║██║╚██╗██║    ████╔╝██║');
    deplacerCurseurXY(13,7);
    write('╚██████╗██║ ╚████╔╝ ██║███████╗██║███████╗██║  ██║   ██║   ██║╚██████╔╝██║ ╚████║    ╚██████╔╝');
    deplacerCurseurXY(13,8);
    write(' ╚═════╝╚═╝  ╚═══╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝  ╚═╝   ╚═╝   ╚═╝ ╚═════╝ ╚═╝  ╚═══╝     ╚═════╝ ');

    deplacerCurseurXY(13,9);
    write('                           ╦  ╔═╗╔╦╗╔═╗╔╦╗╦ ╦╔═╗  ╔═╗╔╦╗╦╔╦╗╦╔═╗╔╗╔');
    deplacerCurseurXY(13,10);
    write('────────────────────────── ║  ╠═╣║║║╠═╣ ║ ╠═╣╚═╗  ║╣  ║║║ ║ ║║ ║║║║ ──────────────────────────');
    deplacerCurseurXY(13,11);
    write('                           ╩═╝╩ ╩╩ ╩╩ ╩ ╩ ╩ ╩╚═╝  ╚═╝═╩╝╩ ╩ ╩╚═╝╝╚╝');
    deplacerCurseurXY(13,12);


    { INTRODUCTION }
    deplacerCurseurXY(4,14);
    write('Bienvenue dans Civilization 0 — Lamaths Edition');

    couleurTexte(8);
    deplacerCurseurXY(4,16);
    write('À la tête d''une Tribu de Lamas mathématiciens, vous menez une guerre sans merci contre les hordes littéraires');
    deplacerCurseurXY(4,17);
    write('qui menacent vos recherches. Affirmez votre supériorité ; résolvez des équations pour améliorer votre élevage');
    deplacerCurseurXY(4,18);
    write('et étalez votre savoir afin de conquérir les pâturages tombés entre les sabots de l''ennemi.');

    deplacerCurseurXY(4,20);
    write('Que les axiomes vous guident !');
    couleurTexte(15);

    { CHOIX }
    deplacerCurseurXY(4,23);
    writeln('1 - Débuter une nouvelle partie');
    deplacerCurseurXY(4,25);
    writeln('2 - Quitter le jeu');

    afficherMessage();
    afficherCadreAction();
    choisir();
  end;

  { Affiche un écran de vérification Quitter ? Oui/Non }
  procedure verifQuitter;

  var
    choix : String; // Valeur entrée par la joueur

  begin
    effacerEcran();

    { Corps de l'écran }
    afficherTitre('VOULEZ-VOUS VRAIMENT QUITTER LA PARTIE ?', 10);
    deplacerCurseurXY(53,14);
    writeln('1 - Non');
    deplacerCurseurXY(53,16);
    writeln('2 - Oui');

    { Partie inférieure de l'écran }
    afficherMessage();
    afficherCadreAction();

    { Déplace le curseur dans le cadre "Action" }
    deplacerCurseurXy(114,26);
    readln(choix);

    { Liste des choix disponibles }
    if (choix = '1') then EcranTribu.afficher();
    if (choix = '2') then EcranAccueil.afficher()

    { Valeur saisie invalide }
    else
    begin
      setMessage('Action non reconnue');
      verifQuitter();
    end;

  end;

end.
