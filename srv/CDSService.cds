using {anubhav.cds} from '../db/CDSView';

service CDSService @(path:'CDSService') {

    entity ProductSet as projection on cds.CDSView.ProductView{
        *,
        //please a virual field to show no. of times this was bought
        virtual purchCount: Int16
    };
    entity ItemSet as projection on cds.CDSView.ItemView;

}