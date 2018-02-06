using System;
using System.Collections.Generic;
using System.Text;
using System.Drawing;
using Screensavers;

namespace PixieSaver
{
	class Pixie
	{

		public Pixie(PixieSaver screensaver)
		{
			this.screensaver = screensaver;
			y = screensaver.Window0.Size.Height;
			x = screensaver.Rand.Next(screensaver.Window0.Size.Width);
			tendency = screensaver.Rand.Next(25, 75);
		}

		readonly static Brush[] palette = InitPalette();
		int tendency;
		int x, y;
		private PixieSaver screensaver;

		static Brush[] InitPalette()
		{
			Brush[] palette = new Brush[128];
			for (int i = 0; i < palette.Length / 2; i++)
			{
				byte val = (byte)(127 - (128 / palette.Length) * i * 2);
				palette[i] = new Pen(Color.FromArgb(val, val, 255)).Brush;
			}

			for (int i = palette.Length / 2; i < palette.Length; i++)
			{
				byte val = (byte)(127 - (128 / palette.Length) * i);
				palette[i] = new Pen(Color.FromArgb(0, 0, (byte)(val * 2 * 2))).Brush;
			}
			return palette;
		}

		public virtual bool Update()
		{
			y--;
			int num = screensaver.Rand.Next(100);
			if (num < tendency)
				x++;
			else
				x--;

			return y <= 0;
		}

		public virtual void Draw()
		{
			screensaver.Graphics0.FillRectangle(palette[screensaver.Rand.Next(palette.Length)], x, y, 2, 2);
		}
	}
}
