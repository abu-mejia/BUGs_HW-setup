# Building digital competencies for detecting and monitoring diseases in moUntain aGriculture fields (BUGs)  
# HW-setup and identification disease algorithm
**Description of the instrumentation to detect and monitor diseases in mountain agriculture based on spectroscopy**

In an nutshell, BUGs proposes a semi-automatic system that provides online thematic models to identify and classify plant diseases in mountain agriculture applications to foster small, localized management areas (centimeter-level resolution – leaves and insects scale). It uses unmanned aerial vehicles to quickly and efficiently manage three contrasting complex mountain scenarios: apple orchard monitoring *Alternaria*, *Plasmopara viticola* in a vineyard, and forest for *Thaumetopoea pityocampa* (Pine processionary).

This project includes the datasheets of the instruments that we use for our PREPARE experiment inside the Smart Agri Hubs project

![index_SmartAgriHubs](https://user-images.githubusercontent.com/22096475/145731180-dfd44ef0-fb9e-4e7c-af67-31b770d36471.png)

---

The _instrumentation_ we use to run these experiments is

* Spectroradiometer HR1024i [Spectravista](https://spectravista.com/instruments/hr-1024i/)
* Micasense Red Edge  [Micasense](https://micasense.com/rededge-mx/)
* Ricoh GR II - RGB camera [Ricoh](https://www.ricoh-imaging.co.jp/english/products/gr-2/)
* FLIR vue pro R - Thermal camera [FLIR](https://www.flir.eu/products/vue-pro-r/)
* GPS Leica system GS14 [Leica](https://leica-geosystems.com/products/gnss-systems/receivers/leica-viva-gs10-gs25)
* Soleon Octocopter [Soleon](https://www.soleon.it/en)

---

The _algorithm_ that we use to classify the spectroradiometer dataset consist on Principal Component Analysis in R

There are two general methods to perform PCA in R :
Spectral decomposition which examines the covariances / correlations between variables
Singular value decomposition which examines the covariances / correlations between individuals

The function **princomp()** uses the spectral decomposition approach. The functions **prcomp()** and **PCA()**[FactoMineR] use the singular value decomposition (SVD).

---

##### This project has received funding from the European Union’s Horizon 2020 research and innovation programme under grant agreement № 818182
![H2020-Emblem_Horizontal_PNG](https://user-images.githubusercontent.com/22096475/145731840-b03cc574-66ef-4b42-b0af-24c1f6fda8b3.png)

