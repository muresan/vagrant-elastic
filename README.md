# vagrant-elastic
ElasticSearch cluster of 3 machines started by Vagrant

    [cata@lemon vagrant-elastic (master)]$ puppet module install -i . elasticsearch-elasticsearch
    Notice: Preparing to install into /home/cata/vagrant-elastic ...
    Notice: Downloading from https://forgeapi.puppetlabs.com ...
    Notice: Installing -- do not interrupt ...
    /home/cata/vagrant-elastic
    └─┬ elasticsearch-elasticsearch (v0.9.9)
      ├── ceritsc-yum (v0.9.6)
      ├── puppetlabs-apt (v1.8.0)
      └── puppetlabs-stdlib (v4.9.0)
