unit EcranElevage;

interface

  { Affichage de l'écran et appel des fonctions & procédures associées }
  procedure afficher();

  { Vérifie l'état d'avancement d'une construction
    et met à jour les variables une fois celle-ci terminée. }
  procedure majConstruction();

  { Vérifie l'état d'avancement de la croissance de l'élevage
    et met à jour les variables une fois celle-ci achevée }
  procedure majCroissance();



implementation

  uses Variables, GestionEcran, OptnAffichage, EcranTribu;


  { Lance la construction d'un bâtiment (Universite, CDR, Laboratoire, Enclos) }
  procedure construire(nomBatiment : String);

  var
    sommeNiveau : Integer; // Somme du niveau de chaque bâtiment

  begin
    { Si aucune construction n'est en cours }
    if getElevage().construction = False then
    begin

      sommeNiveau := getUniversite().niveau
                   + getCDR().niveau
                   + getLaboratoire().niveau
                   + getEnclos().niveau;

      { Si la somme du niveau de chaque bâtiment est inférieure à la population }
      if (sommeNiveau < getElevage().population) then
      begin

        // Université
        if nomBatiment = 'Universite' then
        begin
          { Si le bâtiment n'est pas déjà au niveau maximum }
          if (getUniversite().niveau < getNIVEAU_MAX()) then
          begin
              setElevage_construction(True);
              setUniversite_construction(True);
              setMessage('Construction lancée');
          end
          else setMessage('Ce bâtiment est déjà au niveau maximum');
        end;

        // Centre de recherches
        if nomBatiment = 'CDR' then
        begin
          { Si le bâtiment n'est pas déjà au niveau maximum }
          if (getCDR().niveau < getNIVEAU_MAX()) then
          begin
              setElevage_construction(True);
              setCDR_construction(True);
              setMessage('Construction lancée');
          end
          else setMessage('Ce bâtiment est déjà au niveau maximum');
        end;

        // Laboratoire
        if nomBatiment = 'Laboratoire' then
        begin
          { Si le bâtiment n'est pas déjà au niveau maximum }
          if (getLaboratoire().niveau < getNIVEAU_MAX()) then
          begin
              setElevage_construction(True);
              setLaboratoire_construction(True);
              setMessage('Construction lancée');
          end
          else setMessage('Ce bâtiment est déjà au niveau maximum');
        end;

        // Enclos
        if nomBatiment = 'Enclos' then
        begin
          { Si le bâtiment n'est pas déjà au niveau maximum }
          if (getEnclos().niveau < getNIVEAU_MAX()) then
          begin
              setElevage_construction(True);
              setEnclos_construction(True);
              setMessage('Construction lancée');
          end
          else setMessage('Ce bâtiment est déjà au niveau maximum');
        end;

      end
      else setMessage('Population insuffisante');

    end
    else setMessage('Une construction est déjà en cours');

  end;

  { Remet à 0 les variables liées à la construction }
  procedure reinitConstruction;
  begin
    setElevage_construction(False);
    setElevage_equationsResolues(0);
    setUniversite_construction(False);
    setCDR_construction(False);
    setLaboratoire_construction(False);
    setEnclos_construction(False);
  end;

  { Vérifie l'état d'avancement d'une construction
    et met à jour les variables une fois celle-ci terminée. }
  procedure majConstruction;
  begin
    { Si une construction (encore indéterminée) est en cours }
    if getElevage().construction = True then
    begin

      { On détermine d'abord quel bâtiment est en construction. Ensuite on regarde si le travail accumulé est
        suffisant pour passer au niveau supérieur. Dans le cas d'un passage au niveau supérieur, on met à jour
        le niveau du bâtiment et les bonus liés, et on réinitialise l'état de construction. }


      { Si la construction de l'UNIVERSITE est en cours }
      if getUniversite().construction = True then
      begin
        { Si les équations résolues sont suffisantes pour passer au niveau suivant }
        if getElevage().equationsResolues >= getUniversite().PALIERS[getUniversite().niveau+1] then
        begin
          setUniversite_niveau( getUniversite().niveau + 1 );
          setElevage_savoirJourAbsolu( getElevage().savoirJourAbsolu
                                     + getUniversite().BONUS[getUniversite().niveau] );
          reinitConstruction();
        end;
      end;


      { Si la construction du LABORATOIRE est en cours }
      if getLaboratoire().construction = True then
      begin
        { Si les équations résolues sont suffisantes pour passer au niveau suivant }
        if getElevage().equationsResolues >= getLaboratoire().PALIERS[getLaboratoire().niveau+1] then
        begin
          setLaboratoire_niveau( getLaboratoire().niveau + 1 );
          setElevage_equationsJour( getElevage().population
                                  + getLaboratoire().BONUS[getLaboratoire().niveau]
                                  + getCDR().BONUS[getCDR().niveau] );
          reinitConstruction();
        end;
      end;


      { Si la construction du CDR est en cours }
      if getCDR().construction = True then
      begin
        { Si les équations résolues sont suffisantes pour passer au niveau suivant }
        if getElevage().equationsResolues >= getCDR().PALIERS[getCDR().niveau+1] then
        begin
          setCDR_niveau( getCDR().niveau + 1 );
          setElevage_equationsJour( getElevage().population
                                  + getLaboratoire().BONUS[getLaboratoire().niveau]
                                  + getCDR().BONUS[getCDR().niveau] );
          reinitConstruction();
        end;
      end;

      { Si la construction de l'ENCLOS est en cours }
      if getEnclos().construction = True then
      begin
        { Si les équations résolues sont suffisantes pour passer au niveau suivant }
        if getElevage().equationsResolues >= getEnclos().PALIERS[getEnclos().niveau+1] then
        begin
          setEnclos_niveau( getEnclos().niveau + 1 );
          setTribu_ptsRecrutementJour(getEnclos().BONUS[getEnclos().niveau]);
          reinitConstruction();
        end;
      end;

    end;

  end;

  { Vérifie l'état d'avancement de la croissance de l'élevage
    et met à jour les variables une fois celle-ci achevée }
  procedure majCroissance;
  begin

    { Calcul du savoir/j à partir du savoir/j absolu }
    setElevage_savoirJour(getElevage().savoirJourAbsolu - getElevage().population);

    { Si le savoir acquis permet de croître en population }
    if getElevage().savoirAcquis >= getElevage().seuilCroissance then
    begin
      setElevage_savoirAcquis(0);
      setElevage_population(getElevage().population + 1);
      setElevage_savoirJour(getElevage().savoirJourAbsolu - getElevage().population);
      setElevage_equationsJour( getElevage().population
                              + getLaboratoire().BONUS[getLaboratoire().niveau]
                              + getCDR().BONUS[getCDR().niveau] );
      setElevage_seuilCroissance(getElevage().population * getFACTEUR_CROISSANCE);
    end;

    { Permet de passer directement à une croissance nulle ; évite la division par 0 dans le calcul suivant }
    if getElevage().savoirJour = 0 then setElevage_nbJourAvCroissance(0)
    else setElevage_nbJourAvCroissance( ( getElevage().seuilCroissance
                                        - getElevage().savoirAcquis
                                        + ( getElevage().seuilCroissance mod getElevage().savoirJour))
                                      div getElevage().savoirJour )
  end;



  { Affiche la liste des bâtiments construits aux coordonnées (x,y) }
  procedure afficherBatimentsConstruits(x,y : Integer);

  begin
    deplacerCurseurXY(x,y);
    writeln('Bâtiments construits :');
    deplacerCurseurXY(x,y+1);
    writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');

    { On regarde simplement quel bâtiment est construit (niveau > 0)
      et on affiche son nom et son niveau. }

    // Université
    if getUniversite().niveau > 0 then
    begin
      deplacerCurseurXY(x+2,y+2);
      writeln('- Université (niv ', getUniversite().niveau,')');
    end;

    // Centre de recherches
    if getCDR().niveau > 0 then
    begin
      deplacerCurseurXY(x+2,y+3);
      writeln('- Centre de recherches (niv ', getCDR().niveau,')');
    end;

    // Laboratoire
    if getLaboratoire().niveau > 0 then
    begin
      deplacerCurseurXY(x+2,y+4);
      writeln('- Laboratoire (niv ', getLaboratoire().niveau,')');
    end;

    // Enclos
    if getEnclos().niveau > 0 then
    begin
      deplacerCurseurXY(x+2,y+5);
      writeln('- Enclos (niv ', getEnclos().niveau,')');
    end;
  end;

  { Affiche la liste des bonus accumulés aux coordonnées (x,y) }
  procedure afficherBonus(x,y : Integer);

  begin
    deplacerCurseurXY(x,y);
    writeln('Bonus accumulés :');
    deplacerCurseurXY(x,y+1);
    writeln('¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯');

    { Chaque bonus s'affiche en gris s'il est nul ou False
      et en vert s'il est positif ou True. }

    // Savoir/j
    deplacerCurseurXY(x+2,y+2);
    writeln('Savoir/j : ');
    if getUniversite().BONUS[getUniversite().niveau] = 0 then couleurTexte(8)
    else couleurTexte(10);
    deplacerCurseurXY(x+2+length('Savoir/j : '),y+2);
    writeln('+ ', getUniversite().BONUS[getUniversite().niveau]);
    couleurTexte(15);

    // Equations/j
    deplacerCurseurXY(x+2,y+3);
    writeln('Équations/j : ');
    if getCDR().BONUS[getCDR().niveau] + getLaboratoire().BONUS[getLaboratoire().niveau] = 0 then couleurTexte(8)
    else couleurTexte(10);
    deplacerCurseurXY(x+2+length('Équations/j : '),y+3);
    writeln('+ ', getCDR().BONUS[getCDR().niveau] + getLaboratoire().BONUS[getLaboratoire().niveau]);
    couleurTexte(15);

    // Pts de recrutement
    deplacerCurseurXY(x+2,y+4);
    writeln('Pts de recrut. : ');
    if getEnclos().BONUS[getEnclos().niveau] = 0 then couleurTexte(8)
    else couleurTexte(10);
    deplacerCurseurXY(x+2+length('Pts de recrut. : '),y+4);
    writeln('+ ', getEnclos().BONUS[getEnclos().niveau]);
    couleurTexte(15);

    // Lamas
    deplacerCurseurXY(x+2,y+5);
    writeln('Lamas : ');
    deplacerCurseurXY(x+2+length('Lamas : '),y+5);
    if getEnclos().niveau > 0 then
    begin
      couleurTexte(10);
      writeln('Oui');
    end
    else
    begin
      couleurtexte(8);
      writeln('Non');
    end;
    couleurtexte(15);

    // Alpagas
    deplacerCurseurXY(x+2,y+6);
    writeln('Alpagas : ');
    deplacerCurseurXY(x+2+length('Alpagas : '),y+6);
    if getCDR().niveau >= 1 then
    begin
      couleurTexte(10);
      writeln('Oui');
    end
    else
    begin
      couleurtexte(8);
      writeln('Non');
    end;
    couleurtexte(15);
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
      construire('Universite');
      majConstruction();
      afficher();
    end;

    if (choix = '2') then
    begin
      construire('CDR');
      majConstruction();
      afficher();
    end;

    if (choix = '3') then
    begin
      construire('Laboratoire');
      majConstruction();
      afficher();
    end;

    if (choix = '4') then
    begin
      construire('Enclos');
      majConstruction();
      afficher();
    end;

    if (choix = '0') then
    begin
      EcranTribu.afficher();
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
    afficherEntete();
    dessinerCadreXY(0,6, 119,28, simple, 15,0);
    afficherTitre('ECRAN DE GESTION DE : ' + getElevage().nom, 6);

    { Corps de l'écran }
    afficherElevage(4,10);
    afficherBatimentsConstruits(46,15);
    afficherBonus(84,15);

    { Choix disponibles }
    deplacerCurseurXY(3,21);
    writeln('1 - Construire l''Université');
    deplacerCurseurXY(3,22);
    writeln('2 - Construire le Centre de recherches');
    deplacerCurseurXY(3,23);
    writeln('3 - Construire le Laboratoire');
    deplacerCurseurXY(3,24);
    writeln('4 - Construire l''Enclos');
    deplacerCurseurXY(3,26);
    writeln('0 - Retour au menu');

    { Partie inférieure de l'écran }
    afficherMessage();
    afficherCadreAction();

    choisir();
  end;

end.
