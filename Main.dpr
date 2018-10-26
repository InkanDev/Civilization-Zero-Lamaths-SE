program Main;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  GestionEcran in 'GestionEcran.pas',
  Variables in 'Variables.pas',
  OptnAffichage in 'OptnAffichage.pas',
  EcranAccueil in 'EcranAccueil.pas',
  EcranTribu in 'EcranTribu.pas',
  EcranElevage in 'EcranElevage.pas',
  EcranMilitaire in 'EcranMilitaire.pas',
  EcranCombat in 'EcranCombat.pas';

begin
  initJoueur();
  EcranAccueil.afficher;
end.
