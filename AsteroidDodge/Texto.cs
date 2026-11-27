using Microsoft.Xna.Framework;
using Microsoft.Xna.Framework.Graphics;

namespace AsteroidDodge;

// letras  por  codigo  nomas
// esto  no  es  un  sprite  ni  nada  dibujado  a  mano
public static class Texto
{
    // cada  letra  son  5  filas  de  3  pixeles
    static readonly string[] letras = {
        "111101101101111", // 0
        "010110010010111", // 1
        "111001111100111", // 2
        "111001111001111", // 3
        "101101111001001", // 4
        "111100111001111", // 5
        "111100111101111", // 6
        "111001001001001", // 7
        "111101111101111", // 8
        "111101111001111", // 9
        "010101111101101", // a
        "110101110101110", // b
        "011100100100011", // c
        "110101101101110", // d
        "111100110100111", // e
        "111100110100100", // f
        "011100101101011", // g
        "101101111101101", // h
        "111010010010111", // i
        "001001001101010", // j
        "101101110101101", // k
        "100100100100111", // l
        "101111111101101", // m
        "101111111111101", // n
        "010101101101010", // o
        "110101110100100", // p
        "010101101111011", // q
        "110101110101101", // r
        "011100010001110", // s
        "111010010010010", // t
        "101101101101111", // u
        "101101101101010", // v
        "101101111111101", // w
        "101101010101101", // x
        "101101010010010", // y
        "111001010100111", // z
        "000000000000000", // espacio
        "000000000000010", // punto
        "000000111000000", // guion
        "000010000010000"  // dos puntos
    };

    public static void Dibujar(SpriteBatch sb, Texture2D pixel, string texto, int x, int y, Color color)
    {
        for (int i = 0; i < texto.Length; i++)
        {
            char c = char.ToUpper(texto[i]);
            int id;
            if (c >= '0' && c <= '9') id = c - '0';
            else if (c >= 'A' && c <= 'Z') id = c - 'A' + 10;
            else if (c == ' ') id = 36;
            else if (c == '.') id = 37;
            else if (c == '-') id = 38;
            else id = 39;

            string letra = letras[id];
            for (int fila = 0; fila < 5; fila++)
            {
                for (int col = 0; col < 3; col++)
                {
                    if (letra[fila * 3 + col] == '1')
                    {
                        sb.Draw(pixel, new Rectangle(x + i * 16 + col * 4, y + fila * 4, 4, 4), color);
                    }
                }
            }
        }
    }
}

