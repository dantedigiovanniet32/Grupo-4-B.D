// cola  circular con  un  array  nomas
// no  uso  la  cola  de  .net  porque la  quiero  simple
namespace AsteroidDodge;

public class Cola
{
    // guardo  dos  arrays  fijos,  uno  para  la  x  y  otro  para  el  tipo
    readonly int[] x = new int[16];
    readonly int[] tipo = new int[16];
    int cabeza;
    int final;
    int cantidad;

    // meto  un  pedido  al  final  de  la  cola
    public void Poner(int px, int ptipo)
    {
        if (cantidad == 16) return; // si  esta  llena  no  hago  nada
        x[final] = px;
        tipo[final] = ptipo;
        final = (final + 1) % 16; // cuando  llega  al  final  vuelve  al  principio
        cantidad++;
    }

    // saco  el  primero  que  entro
    public bool Sacar(out int px, out int ptipo)
    {
        px = 0;
        ptipo = 0;
        if (cantidad == 0) return false;
        px = x[cabeza];
        ptipo = tipo[cabeza];
        cabeza = (cabeza + 1) % 16;
        cantidad--;
        return true;
    }

    public int Cantidad { get { return cantidad; } }
}

