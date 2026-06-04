BeginPackage["JosephBrennan`StravaLink`"];

(* No public symbols exported from this file *)

Begin["`Private`"];

$GPXImportElements = 
{
    "Comments", "Data", "Graphics", "GraphicsList", "LayerNames", 
    "Metadata", "Name", "SpatialRange", "Summary", "TabularAssociation"
};

$ActivityStreamTypesWolfram = 
{
	"Time", "Distance", "Altitude", "Coordinates", "Velocity", "HeartRate", 
	"Cadence", "Watts", "Temperature", "Moving", "Grade"
};

$ActivityStreamTypesStrava = 
{
	"time", "distance", "altitude", "latlng", "velocity_smooth", "heartrate", 
	"cadence", "watts", "temp", "moving", "grade_smooth"
};

activityStreamTypeMapping = 
AssociationThread[
	$ActivityStreamTypesWolfram,
	$ActivityStreamTypesStrava
];

(* Other shared private utilities, constants, or helper functions *)

End[];
EndPackage[];