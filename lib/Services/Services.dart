import 'package:flutter/material.dart';
import 'package:http/http.dart';


class Services{

  Future<Response> getResponse() async{
    Response rep = await get('https://data.enseignementsup-recherche.gouv.fr/api/records/1.0/search/?dataset=fr-esr-fete-de-la-science-19&q=&facet=dates&facet=selection&facet=type_d_animation&facet=mots_cles_fr&facet=thematiques&facet=en_une&facet=statut&facet=identifiant_du_lieu&facet=tags_du_lieu&facet=identifiant&refine.identifiant=92857507');
    return rep;
  }

}