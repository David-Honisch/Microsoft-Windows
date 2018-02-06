using System;
using System.Drawing;
using System.Collections.Generic;
using System.Text;
using Screensavers;

namespace PixieSaver
{
	class PixieSaver : Screensaver
	{
		public PixieSaver()
			: base(FullscreenMode.SingleWindow)
		{
			this.Initialize += new EventHandler(PixieSaver_Initialize);
			this.Update += new EventHandler(PixieSaver_Update);

			this.SettingsText = "webmaster@letztechance.org";
		}

		[STAThread]
		static void Main()
		{
			PixieSaver ps = new PixieSaver();
			ps.Run();
		}

		Random rand = new Random();
		public Random Rand
		{
			get { return rand; }
		}

		public void AddPixie(Pixie pixie)
		{
			pixies.Add(pixie);
		}

		List<Pixie> pixies = new List<Pixie>();

		void PixieSaver_Update(object sender, EventArgs e)
		{
			DoUpdate();
			DoRender();
		}

		int interval;

		void DoUpdate()
		{
			if (interval == 5)
			{
				pixies.Add(new Pixie(this));
				interval = 0;
			}
			interval++;

			for (int i = 0; i < pixies.Count; i++)
				if (pixies[i].Update())
				{
					pixies.RemoveAt(i);
					i--;
				}
		}

		void DoRender()
		{
			Graphics0.Clear(Color.Black);

			foreach (Pixie pixie in pixies)
				pixie.Draw();
		}

		void PixieSaver_Initialize(object sender, EventArgs e)
		{
			//Update enough times to fill the screen with pixies
			for (int i = 0; i < Window0.Size.Height; i++)
				DoUpdate();
		}
	}
}
