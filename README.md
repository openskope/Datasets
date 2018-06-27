# SKOPE Datasets and Models
SKOPE uses a database called Elasticsearch to maintain records (documents) of
each dataset and model. The web app's search page queries the database to
find datasets of interest and displays those as a real-time filterable list
of cards. 

The content created here is directly visible within the web app once loaded
into Elasticsearch. Team members are encourage to add and modify the 
information stored here to improve the information presented to uses.


## Defining Datasets for SKOPE Search and Workspace Use
SKOPE datasets and models are defined as a multipart document with structured metadata stored in a JSON document and unstructure, informational content being stored in individual markdown files, images, and geojson files. A post processing tool integrates the component documents and loads the Elasticsearch database. The dataset.json file is required (even for models); all other documents are optional. 

_The original [SKOPE Dataset sheet](https://docs.google.com/spreadsheets/d/1cRuFuIiwNc15KIzPM0VifjGJqz8LgKC4Tsq92dO43zQ/edit?usp=sharing) is still useful but new documentatation will be moved to this repository._

### dataset.json
The section below shows a minimal dataset.json file. The load tool assists in creating the full record used 
within Elasticsearch database by merging supplementary files stored in the same folder. Using this mechanism,
new datasets can be added and changed simply by changing the repository data potentially using GitHub's built-in
editing capabilities.

```json
{
  "type": "dataset",
  "title": "SW USA 2000 Year Growing Degree Days and Precipitation Reconstructions",
  "description": "Humans experience, adapt to and influence climate at local scales. Paleoclimate research, 
  however, tends to focus on  continental, hemispheric or global scales, making it difficult for archaeologists
  and paleoecologists to study local effects.",

  "revised": "2016-04-01",
  
  "variables": [
    { 
      "name": "Growing Degree Days",
      "url": "http://openskope.org/variables/gdd.htm",
      "description": "Growing Degree Days are calculated as the aggregation of temperature daily high minus base 
      value for every day in the growing season"
    },
    { 
      "name": "Annual Precipitation",
      "url": "http://openskope.org/variables/ppt.htm",
      "description": "Total annual precipitation",
    }
  ],

  "region": {
    "name": "Southwestern USA",
    "extents": [ "31", "43", "-115", "-102" ],
  },

  "timespan": {
    "name": "0000-2000CE",
    "resolution": "year",
    "period": {
      "gte": "0000",
      "lte": "2000"
    },
  },
}
```
#### type field
Controls specific rendering of the search card. Generally should be set to 'dataset'.

#### title field
The dataset title should be a brief 40-60 character string. (see also description.md)

#### description field
Short description of the dataset. Generally 2-3 sentences in length. (see also description.md)

#### revised field
A date in the format yyyy-mm-dd. The date is displayed as a subtitle on the search card. The date can
represent the most useful date depending on context. For instance, the publication date might make sense
for data is the associated with a formal paper. If the dataset represent data maintained by a third party, 
the date might represent when the last copy made. If the dataset represent a run of a model, it might
represent when the model execution completed.

#### publisher field
The publisher name should represent primary publisher of the dataset data. For models run by
the SKOPE system this will be SKOPE.

#### variables field
Variables are one of the most import elements of the SKOPE system and each dataset. Variables
should use will defined names pre-defined by SKOPE staff. Variables are frequently associated with
map overlays and the ability to download data. Therefore, the string provided in the name subfield
should be choosen with care and ensure that it matches similar names used in other datasets.

#### region field
The region field defines the spatial area of the dataset. Two subfields are used, _name_ represents
a descriptive name for the area. The _extents_ is an array of the form [min lat, max lat, min long, max long].

If a geojson boundary file is not available the extents are used to automatically create an bounding rectangle.

#### timespan field
The timespan field defined the temporal extent of the dataset. Two subfields are used, _name_ represents
a descriptive name (i.e. 0000-2000CE) for the timespan. The _period_ should match this descriptive name
using starting (gte) and ending (lte) dates in the form of year (yyyy) or year-month (yyyy-mm).

### Supporting Files
The following files are automatically read during processing of the dataset and includes as part of the dataset.json
document. 

#### description.md
The description.md is the primary content displayed for SKOPE search result cards. Given the limited space
available on each card, the author should attempt to keep the description as brief as possible (2-3 sentences).
But remember that users will be evaluating the dataset using this description. Focus on the information they will
likely need. Also remember that the information.md provides an opportunity to enhance the information provided.

During processing, the description.md content automatically overwrites the description field in the dataset.json file. 
If a title line (single #) is present, it will overwrite the dataset.json title and is removed from the description.

#### information.md
The information.md is a place to get creative with the description of the dataset. Any information important
for the researcher should be placed within this document. This can include formal abstracts, authors or
or researcher names, publication citations, study notes, etc. Remember to use the full power of markdown
when creating this file.

The contents of the information.md is included in Elasticsearch and available as part of full text searches.

**Originator:** The individual or organization responsible for the dataset's creation.

**Spatial Coverage:** A description of the area for which data are available plus the spatial resolution.

**Temporal Coverage:** The temporal range of values and their temporal resolution.

**Variables:** A list of the variables included in the dataset (each starting on a new line) providing a name, units in which the variable is measured, and any information needed concerning its computation or interpretation by the user.

**Method Summary and Comments** A desciption that should be readable by a normal researcher describing how the modeled data is calculated.

**Uncertainty** For the variables in the dataset (separate description by variable if necessary), indicate what the uncertainty values reported in the dataset mean and a brief description of how they are calculated.

**Data Archived At:** Provide the URL where the full dataset may be downloaded.

**References** Key references describing the dataset and underlying model.  Provide URL if available.

**Date Last Revised:** The date of the last update to the dataset.

**Contact Information:** Contact information for the dataset provider. 

#### boundary.geojson
The boundary defining the dataset. The boundary is multiple purposed, used both for display within the search card and as 
part of the workspace layers tab and the part of the spatial search capabilities. Datasets without boundary information
are automatically excluded from any spatial searchers.

If the boundary.geojson is not present, a basic rectangular boundary will be automatically generated from the region.extents
field.

#### downloads.md
This file describes the data that is available for download. It should include a technical summary of the
data and any restriction of the use or licenses associated with the data, how to report issues, etc. If the
data is not generally available, this file could provide contact information to request access.  

#### downloads.json
If the data is being made available from SKOPE, this additional document will include the necessary parameters
to support format conversion, spatial clipping, etc. 

#### overlays.md
If the data is available in map overlay form (i.e from a tile server), this document should describe the
availability and any terms of use.

#### overlays.json
This document provides the technical details of accessing the overlays with the workspace display and 
includes the url endpoints of the tile service and any parameters necessary for accessing the service. If 
the overlays are generated by the SKOPE geoserver the min, max, and style fields provide the information 
necessary to modify the rendering of the tiles dynamically.

#### analytics.md
This document describes the analytics services such as graph generation available for a dataset. Analytics
are only available for a select set of data which is hosted on SKOPE servers.

#### analytics.json
This document provides the technical details necessary to drive the analytics capabilities of the workspace.
The exact details of this are still work-in-progress.

### model.md
This documents provide details about the model that generated the scenario and the ability to re-run using the
Tinkerer interface.




