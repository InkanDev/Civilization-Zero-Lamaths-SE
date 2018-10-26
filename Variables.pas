unit Variables;

interface

  type

  { Repr�sente une Tribu (Civilisation) et ses caract�ristiques }
  TTribu = record
    nom     : String; // Nom de la Tribu
    numJour : Integer; // Num�ro du Jour (Tour)
    ptsRecrutement     : Integer; // Points de recrutement dont dispose le joueur
    ptsRecrutementJour : Integer; // Points de recrutement dont dispose le joueur par jour
  end;

  { Repr�sente un Elevage (Ville) et ses caract�ristiques }
  TElevage = record
    nom          : String;   // Nom de l'�levage
    population   : Integer;  // Population totale de l'�levage
    construction : Boolean ; // Etat de construction de l'�levage

    savoirJourAbsolu : Integer; // Valeur absolue du savoir acquis chaque jour
    savoirJour       : Integer; // Valeur r�elle du savoir acquis chaque jour (- la population)
    savoirAcquis     : Integer; // Savoir total acquis pendant la phase de croissance

    seuilCroissance    : Integer; // Savoir � acqu�rir pour cro�tre (+1 population)
    nbJourAvCroissance : Integer; // Nb de jours restant avant de cro�tre

    equationsJour     : Integer; // Nb d'�quations r�solues par jour
    equationsResolues : Integer; // Nb total d'�quations r�solues pendant la phase de construction
  end;

  { Repr�sente un b�timent et ses caract�ristiques }
  TBatiment = record
    nom          : String;    // Nom du b�timent
    niveau       : Integer;   // Niveau du b�timent
    construction : Boolean;   // Etat de construction du b�timent
    PALIERS      : Array[0..3] of Integer;  // Paliers de construction/am�lioration � atteindre
    BONUS        : Array[0..3] of Integer;  // Bonus apport�s par le b�timent
  end;

  { Repr�sente une unit� de combat et ses caract�ristiques }
  TUnite = record
    nom        : String;  // Nom de l'unit�
    nb         : Integer; // Nombre d'�l�ments de l'unit�
    ptsAttaque : Integer; // Pts d'attaque que vaut une unit�
    prix       : Integer; // Pts � d�penser pour acqu�rir une unit�
  end;



  { FONCTIONS & PROCEDURES }
    { Les GETTERS sont utilis�s afin de r�cup�rer l'information d'une entit� locale depuis une autre unit�. }
    { Les SETTERS sont utilis�s afin de modifier une entit� locale depuis d'une autre unit�. }


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
    NIVEAU_MAX = 3; // Niveau maximum que peuvent atteindre les b�timents
    FACTEUR_CROISSANCE = 10; // Facteur intervenant dans le calcul du seuilCroissance

  var
    { Cr�ation des principales entit�s du jeu }

    Tribu       : TTribu; // Tribu (Civilisation)

    Elevage     : TElevage; // Elevage (Ville)

    Universite  : TBatiment; // B�timent UNIVERSITE (Ferme)
    CDR         : TBatiment; // B�timent CENTRE DE RECHERCHES (Mine)
    Laboratoire : TBatiment; // B�timent LABORATOIRE (Carri�re)
    Enclos      : TBatiment; // B�timent ENCLOS (Caserne)

    Lama        : TUnite; // Unit� LAMA (Soldat)
    Alpaga      : TUnite; // Unit� ALPAGA (Canon)




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
    { Les proc�dures suivantes servent � initialiser les variables de jeu. }

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
      { Universit� }
        procedure initUniversite;
        begin
          with Universite do
          begin
            nom          := 'Universit�';
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
