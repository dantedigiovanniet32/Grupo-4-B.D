namespace AsteroidDodge;

public static class Archivos
{
    public static string nombre = "Jugador";

    // leo  el  config  y  si  no  esta  uso  el  nombre  de  siempre
    public static void LeerConfig()
    {
        try
        {
            if (!File.Exists("config.conf")) return;
            string[] lineas = File.ReadAllLines("config.conf");
            for (int i = 0; i < lineas.Length; i++)
            {
                if (lineas[i].StartsWith("jugador=")) nombre = lineas[i].Substring(8);
            }
        }
        catch (Exception)
        {
            nombre = "Jugador"; // rompio  pero  sigo  igual
        }
    }

    // guardo  el  puntaje  en  un  archivo  de  texto  nomas
    public static void GuardarPuntaje(int puntos)
    {
        try
        {
            File.AppendAllText("puntajes.dat", nombre + ";" + puntos + Environment.NewLine);
        }
        catch (Exception)
        {
            // si  no  puedo  escribir  no  me  importa  nomas
        }
    }

    // aca  esta  el  algoritmo  de  la  burbuja,  comparo  de  a  dos
    public static string[] Top5()
    {
        string[] resultado = new string[5];
        try
        {
            string[] lineas = File.ReadAllLines("puntajes.dat");
            int[] pts = new int[500];
            string[] nombres = new string[500];
            int n = 0;
            for (int i = 0; i < lineas.Length && n < 500; i++)
            {
                string[] partes = lineas[i].Split(';');
                if (partes.Length < 2) continue;
                if (!int.TryParse(partes[1], out int p)) continue;
                pts[n] = p;
                nombres[n] = partes[0];
                n++;
            }

            // burbuja  simple,  el  mas  grande  va  subiendo
            for (int i = 0; i < n; i++)
            {
                for (int j = 0; j + 1 < n; j++)
                {
                    if (pts[j] < pts[j + 1])
                    {
                        int t = pts[j];
                        pts[j] = pts[j + 1];
                        pts[j + 1] = t;
                        string s = nombres[j];
                        nombres[j] = nombres[j + 1];
                        nombres[j + 1] = s;
                    }
                }
            }

            for (int i = 0; i < 5; i++)
            {
                resultado[i] = i < n ? (i + 1) + ". " + nombres[i] + " " + pts[i] : "";
            }
        }
        catch (Exception)
        {
            // no  hay  archivo,  devuelvo  todo  vacio
        }
        return resultado;
    }
}

