unit Variables;

interface

  type

  { Représente une Tribu (Civilisation) et ses caractéristiques }
  TTribu = record
    nom     : String; // Nom de la Tribu
    numJour : Integer; // Numéro du Jour (Tour)
    ptsRecrutement     : Integer; // Points de recrutement dont dispose le joueur
    ptsRecrutementJour : Integer; // Points de recrutement dont dispose le joueur par jour
  end;

  { Représente un Elevage (Ville) et ses caractéristiques }
  TElevage = record
    nom          : String;   // Nom de l'élevage
    population   : Integer;  // Population totale de l'élevage
    construction : Boolean ; // Etat de construction de l'élevage

    savoirJourAbsolu : Integer; // Valeur absolue du savoir acquis chaque jour
    savoirJour       : Integer; // Valeur réelle du savoir acquis chaque jour (- la population)
    savoirAcquis     : Integer; // Savoir total acquis pendant la phase de croissance

    seuilCroissance    : Integer; // Savoir à acquérir pour croître (+1 population)
    nbJourAvCroissance : Integer; // Nb de jours restant avant de croître

    equationsJour     : Integer; // Nb d'équations résolues par jour
    equationsResolues : Integer; // Nb total d'équations résolues pendant la phase de construction
  end;

  { Représente un bâtiment et ses caractéristiques }
  TBatiment = record
    nom          : String;    // Nom du bâtiment
    niveau       : Integer;   // Niveau du bâtiment
    construction : Boolean;   // Etat de construction du bâtiment
    PALIERS      : Array[0..3] of Integer;  // Paliers de construction/amélioration à atteindre
    BONUS        : Array[0..3] of Integer;  // Bonus apportés par le bâtiment
  end;

  { Représente une unité de combat et ses caractéristiques }
  TUnite = record
    nom        : String;  // Nom de l'unité
    nb         : Integer; // Nombre d'éléments de l'unité
    ptsAttaque : Integer; // Pts d'attaque que vaut une unité
    prix       : Integer; // Pts à dépenser pour acquérir une unité
  end;



  { FONCTIONS & PROCEDURES }
    { Les GETTERS sont utilisés afin de récupérer l'information d'une entité locale depuis une autre unité. }
    { Les SETTERS sont utilisés afin de modifier une entité locale depuis d'une autre unité. }


  // CONSTANTES
    { Get }
      function getNIVEAU_MAX : Integer;
      function getFACTEUR_CROISSANCE : Integer;


  // TRIBU
    { Get }
      function getTribu : TTribu;
    { Set }
      procedure setTribu_nom                (nom : String);
      procedure setTribu_numJour            (numJour : Integer);
      procedure setTribu_ptsRecrutement     (ptsRecrutement : Integer);
      procedure setTribu_ptsRecrutementJour (ptsRecrutementJour : Integer);


  // ELEVAGE
    { Get }
      function getElevage : TElevage;
    { Set }
      procedure setElevage_nom                (nom : String);
      procedure setElevage_population         (population : Integer);
      procedure setElevage_construction       (construction : Boolean);
      procedure setElevage_savoirJourAbsolu   (savoirJourAbsolu : Integer);
      procedure setElevage_savoirJour         (savoirJour : Integer);
      procedure setElevage_savoirAcquis       (savoirAcquis : Integer);
      procedure setElevage_seuilCroissance    (seuilCroissance : Integer);
      procedure setElevage_nbJourAvCroissance (nbJourAvCroissance : Integer);
      procedure setElevage_equationsJour      (equationsJour : Integer);
      procedure setElevage_equationsResolues  (equationsResolues : Integer);


  // UNIVERSITE
    { Get }
      function getUniversite : TBatiment;
    { Set }
      procedure setUniversite_niveau       (niveau : Integer);
      procedure setUniversite_construction (construction : Boolean);

  // CENTRE DE RECHERCHES
    { Get }
      function getCDR : TBatiment;
    { Set }
      procedure setCDR_niveau       (niveau : Integer);
      procedure setCDR_construction (construction : Boolean);

  // LABORATOIRE
    { Get }
      function getLaboratoire : TBatiment;
    { Set }
      procedure setLaboratoire_niveau       (niveau : Integer);
      procedure setLaboratoire_construction (construction : Boolean);

  // ENCLOS
    { Get }
      function getEnclos : TBatiment;
    { Set }
      procedure setEnclos_niveau       (niveau : Integer);
      procedure setEnclos_construction (construction : Boolean);


  // LAMA
    { Get }
      function getLama : TUnite;
    { Set }
      procedure setLama_nb(nb : Integer);

  // ALPAGA
    { Get }
      function getAlpaga : TUnite;
    { Set }
      procedure setAlpaga_nb(nb : Integer);



  { INITIALISATION DU JOUEUR }
    procedure initJoueur;



implementation

  const
    NIVEAU_MAX = 3; // Niveau maximum que peuvent atteindre les bâtiments
    FACTEUR_CROISSANCE = 10; // Facteur intervenant dans le calcul du seuilCroissance

  var
    { Création des principales entités du jeu }

    Tribu       : TTribu; // Tribu (Civilisation)

    Elevage     : TElevage; // Elevage (Ville)

    Universite  : TBatiment; // Bâtiment UNIVERSITE (Ferme)
    CDR         : TBatiment; // Bâtiment CENTRE DE RECHERCHES (Mine)
    Laboratoire : TBatiment; // Bâtiment LABORATOIRE (Carrière)
    Enclos      : TBatiment; // Bâtiment ENCLOS (Caserne)

    Lama        : TUnite; // Unité LAMA (Soldat)
    Alpaga      : TUnite; // Unité ALPAGA (Canon)




  // CONSTANTES
    { Get }
      function getNIVEAU_MAX : Integer;
      begin
        getNIVEAU_MAX := NIVEAU_MAX;
      end;
      function getFACTEUR_CROISSANCE : Integer;
      begin
        getFACTEUR_CROISSANCE := FACTEUR_CROISSANCE;
      end;


  // TRIBU
    { Get }
      function getTribu : TTribu;
      begin
        getTribu := Tribu;
      end;
    { Set }
      procedure setTribu_nom                (nom : String);
      begin
        Tribu.nom := nom;
      end;
      procedure setTribu_numJour            (numJour : Integer);
      begin
        Tribu.numJour := numjour;
      end;
      procedure setTribu_ptsRecrutement     (ptsRecrutement : Integer);
      begin
        Tribu.ptsRecrutement := ptsRecrutement;
      end;
      procedure setTribu_ptsRecrutementJour (ptsRecrutementJour : Integer);
      begin
        Tribu.ptsRecrutementJour := ptsRecrutementJour;
      end;


  // ELEVAGE
    { Get }
      function getElevage : TElevage;
      begin
        getElevage := Elevage;
      end;
    { Set }
      procedure setElevage_nom                (nom : String);
      begin
        Elevage.nom := nom;
      end;
      procedure setElevage_population         (population : Integer);
      begin
        Elevage.population := population;
      end;
      procedure setElevage_construction       (construction : Boolean);
      begin
        Elevage.construction := construction;
      end;
      procedure setElevage_savoirJourAbsolu   (savoirJourAbsolu : Integer);
      begin
        Elevage.savoirJourAbsolu := savoirJourAbsolu;
      end;
      procedure setElevage_savoirJour         (savoirJour : Integer);
      begin
        Elevage.savoirJour := savoirJour;
      end;
      procedure setElevage_savoirAcquis       (savoirAcquis : Integer);
      begin
        Elevage.savoirAcquis := savoirAcquis;
      end;
      procedure setElevage_seuilCroissance    (seuilCroissance : Integer);
      begin
        Elevage.seuilCroissance := seuilCroissance;
      end;
      procedure setElevage_nbJourAvCroissance (nbJourAvCroissance : Integer);
      begin
        Elevage.nbJourAvCroissance := nbJourAvCroissance;
      end;
      procedure setElevage_equationsJour      (equationsJour : Integer);
      begin
        Elevage.equationsJour := equationsJour;
      end;
      procedure setElevage_equationsResolues  (equationsResolues : Integer);
      begin
        Elevage.equationsResolues := equationsResolues;
      end;


  // UNIVERSITE
    { Get }
      function getUniversite : TBatiment;
      begin
        getUniversite := Universite;
      end;
    { Set }
      procedure setUniversite_niveau       (niveau : Integer);
      begin
        Universite.niveau := niveau;
      end;
      procedure setUniversite_construction (construction : Boolean);
      begin
        Universite.construction := construction;
      end;

  // CENTRE DE RECHERCHES
    { Get }
      function getCDR : TBatiment;
      begin
        getCDR := CDR;
      end;
    { Set }
      procedure setCDR_niveau       (niveau : Integer);
      begin
        CDR.niveau := niveau;
      end;
      procedure setCDR_construction (construction : Boolean);
      begin
        CDR.construction := construction;
      end;

  // LABORATOIRE
    { Get }
      function getLaboratoire : TBatiment;
      begin
        getLaboratoire := Laboratoire;
      end;
    { Set }
      procedure setLaboratoire_niveau       (niveau : Integer);
      begin
        Laboratoire.niveau := niveau;
      end;
      procedure setLaboratoire_construction (construction : Boolean);
      begin
        Laboratoire.construction := construction;
      end;

  // ENCLOS
    { Get }
      function getEnclos : TBatiment;
      begin
        getEnclos := Enclos;
      end;
    { Set }
      procedure setEnclos_niveau       (niveau : Integer);
      begin
        Enclos.niveau := niveau;
      end;
      procedure setEnclos_construction (construction : Boolean);
      begin
        Enclos.construction := construction;
      end;


  // LAMA
    { Get }
      function getLama : TUnite;
      begin
        getLama := Lama;
      end;
    { Set }
      procedure setLama_nb(nb : Integer);
      begin
        Lama.nb := nb;
      end;

  // ALPAGA
    { Get }
      function getAlpaga : TUnite;
      begin
        getAlpaga := Alpaga;
      end;
    { Set }
      procedure setAlpaga_nb(nb : Integer);
      begin
        Alpaga.nb := nb;
      end;




  { INITIALISATION DES VARIABLES }
    { Les procédures suivantes servent à initialiser les variables de jeu. }

    // TRIBU
      procedure initTribu;
      begin
        with Tribu do
        begin
          nom                := 'TribuParDefaut';
          numJour            := 1;
          ptsRecrutement     := 0;
          ptsRecrutementJour := 0;
        end;
      end;

    // Elevage
      procedure initElevage;
      begin
        with Elevage do
        begin
          nom           := 'ElevageParDefaut';
          population    := 1;
          construction  := False;

          savoirJourAbsolu := 2;
          savoirJour       := savoirJourAbsolu - population;
          savoirAcquis     := 0;

          seuilCroissance    := population * FACTEUR_CROISSANCE;
          nbJourAvCroissance := seuilCroissance div savoirJour;

          equationsJour     := population;
          equationsResolues := 0;
        end;
      end;

    // BATIMENTS
      { Université }
        procedure initUniversite;
        begin
          with Universite do
          begin
            nom          := 'Université';
            niveau       := 0;
            construction := False;

            PALIERS[0] := 0;
            PALIERS[1] := 40;
            PALIERS[2] := 180;
            PALIERS[3] := 280;

            BONUS[0] := 0;
            BONUS[1] := 2;
            BONUS[2] := 6;
            BONUS[3] := 9;
          end;
        end;
      { Centre de recherches }
        procedure initCDR;
        begin
          with CDR do
          begin
            nom          := 'Centre de recherches';
            niveau       := 0;
            construction := False;

            PALIERS[0] := 0;
            PALIERS[1] := 80;
            PALIERS[2] := 160;
            PALIERS[3] := 300;

            BONUS[0] := 0;
            BONUS[1] := 1;
            BONUS[2] := 4;
            BONUS[3] := 7;
          end;
        end;
      { Laboratoire }
        procedure initLaboratoire;
        begin
          with Laboratoire do
          begin
            nom          := 'Laboratoire';
            niveau       := 0;
            construction := False;

            PALIERS[0] := 0;
            PALIERS[1] := 80;
            PALIERS[2] := 160;
            PALIERS[3] := 300;

            BONUS[0] := 0;
            BONUS[1] := 3;
            BONUS[2] := 6;
            BONUS[3] := 9;
          end;
        end;
      { Enclos }
        procedure initEnclos;
        begin
          with Enclos do
          begin
            nom          := 'Enclos';
            niveau       := 0;
            construction := False;

            PALIERS[0] := 0;
            PALIERS[1] := 80;
            PALIERS[2] := 240;
            PALIERS[3] := 480;

            BONUS[0] := 0;
            BONUS[1] := 4;
            BONUS[2] := 10;
            BONUS[3] := 20;
          end;
        end;

    // UNITES
      { Lama }
        procedure initLama;
        begin
          with Lama do
          begin
            nom        := 'Lama';
            nb         := 20;
            ptsAttaque := 1;
            prix       := 1;
          end;
        end;
      { Alpaga }
        procedure initAlpaga;
        begin
          with Alpaga do
          begin
            nom        := 'Alpaga';
            nb         := 0;
            ptsAttaque := 2;
            prix       := 2;
          end;
        end;

    // INITIALISATION DU JOUEUR (regroupe tous les init)
    procedure initJoueur;
    begin
      initTribu();
      initElevage();

      initUniversite();
      initCDR();
      initLaboratoire();
      initEnclos();

      initLama();
      initAlpaga();
    end;

end.
