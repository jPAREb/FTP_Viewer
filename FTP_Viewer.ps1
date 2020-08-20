#################################
#       JORDI PARÉ BERNADÓ      #
#################################
#        TWITTER ~@_xJPBx_~     #
#        INSTAGRAM ~jpareb~     #
# GMAIL~jparebernado@gmail.com~ #
#################################
$carpeta = Get-Location
function LOG-Proces($comentari)
{
    
    Write-Host $comentari

}



function Dades-Login{
    
  
    $array_dades = @()
    $array_dades += Read-Host 'Server'
    $array_dades += Read-Host 'Usuario'
    $array_dades += Read-Host 'Contraseña'
    $array_dades += "/"
    $array_dades += Read-Host 'Arxiu'
    return $array_dades
}


function FTP-Connect($server, $usuari, $contrasenya, $directori, $arxiu)
{
    try
    {
        #CREAR URI = ADREÇA SERVIDOR + DIRECTORI
        $uri = "$server$directori"
        LOG-Proces "VARIABLE URI CREADA"

        #CREAR UNA INSTÀNCIA DEL FTPWEBREQUEST
        $sollicitud_ftp = [System.Net.FtpWebRequest]::Create($uri)
        LOG-Proces "URI CREADA"

        #AFEGIR LES CREDENCIALS PER LOGAR-SE
        $sollicitud_ftp.Credentials = New-Object System.Net.NetworkCredential($usuari, $contrasenya)
        LOG-Proces "CREDENCIALS AFEGIDES"

        $sollicitud_ftp.UseBinary = $False
        $sollicitud_ftp.KeepAlive = $False

        #ESPECIFICARÉ UN METODE PER TAL DE LLISTAR ELS ELEMENTS. PER TENIR UN MAJOR DETALL: ListDirectoryDetails
        $sollicitud_ftp.Method = [System.Net.WebRequestMethods+Ftp]::ListDirectoryDetails
        LOG-Proces "METODE ESPECIFICAT"

        #OBTENIR UNA RESPOSTA DEL SERVIDOR FTP
        $resposta_ftp = $sollicitud_ftp.GetResponse()
        LOG-Proces "RESPOSTA OBTINGUDA"
        #OBTENIR EL FLUXE DE DADES DE LA RESPOSTA
        $elements_resposta_ftp = $resposta_ftp.GetResponseStream()
        LOG-Proces "TRANSFORMANT RESPOSTA PER LLEGIR"
        #LLEGIR EL FLUX DE DADES
        $llegir_dades = New-Object System.IO.StreamReader $elements_resposta_ftp
        LOG-Proces "DADES GUARDADES EN VARIABLE"

        $array_elements = [System.Collections.ArrayList] @()
        $elements_sep = [System.Collections.ArrayList] @()
        LOG-Proces "ARRAYS CREADES"
        while($element = $llegir_dades.ReadLine())
        {
            $elements_sep = $element.Split(" ")
            LOG-Proces "ELEMENT REGISTRAT"
            $info_dir = $elements_sep[0]
            LOG-Proces "REGISTRAT TIPUS D'ELEMENT"
            $nom_el = $elements_sep[$test.Length-1]
            LOG-Proces "REGISTRAT NOM D'ELEMENT"
            
            if($info_dir[0] -eq 'd')
            {
                LOG-Proces "L'ELEMENT ES UN DIRECTORI"
                FTP-Connect $server $usuari $contrasenya "$directori$nom_el/" $arxiu
                LOG-Proces "REGISTRAT TOTS ELS ARXIUS DE LA CARPETA"


            }else
            {
                LOG-Proces "L'ELEMENT ES UN ARXIU"
                if($nom_el -like "*$arxiu*")
                {
                    LOG-Proces "ARXIU TROBAT!"
                    Write-Host $directori$nom_el
                    
                }
            }
                    
        }
        $array_elements.clear()
        $elements_sep.clear()
        LOG-Proces "NETEJANT ARRAYS"
    }
    catch
    {
        #ESCRIU L'ERROR
        write-host -message $_.Exception.InnerException.Message
    }
    #$resposta_ftp.Close()
    #$llegir_dades.Close()
    #$elements_resposta_ftp.Close()
}

$dades_con = Dades-Login
FTP-Connect $dades_con[0] $dades_con[1] $dades_con[2] $dades_con[3] $dades_con[4]
#ftp://speedtest.tele2.net/

#################################
#       JORDI PARÉ BERNADÓ      #
#################################
#        TWITTER ~@_xJPBx_~     #
#        INSTAGRAM ~jpareb~     #
# GMAIL~jparebernado@gmail.com~ #
#################################
