import { FileText, AlertTriangle, Users, Car } from "lucide-react";
import {
  BarChart,
  Bar,
  XAxis,
  YAxis,
  CartesianGrid,
  ResponsiveContainer,
} from "recharts";

const MOIS = ["Jan", "Fév", "Mar", "Avr", "Mai", "Jun", "Jul", "Aoû", "Sep", "Oct", "Nov", "Déc"];

export default function Dashboard({ constats }) {
  const total = constats.length;
  const avecBlesses = constats.filter((c) => c.blesses).length;
  const avecTemoins = constats.filter((c) => c.temoins).length;
  const degatsMateriels = constats.filter((c) => c.degatsMateriels).length;

  //Regroupement par mois pour le graphique
  const parMois = MOIS.map((label, index) => {
    const count = constats.filter((c) => {
      if(!c.dateAccident) return false;
      return new Date(c.dateAccident).getMonth() === index;
    }).length;
    return { 
      mois: label,
      count,
    };
  });  

  const stats = [
    { label: "Constats au total", value: total, icon: FileText, color: "var(--accent)", bg: "#FBEAE4" },
    { label: "Avec blessés", value: avecBlesses, icon: AlertTriangle, color: "var(--alerte)", bg: "#FBE7E9" },
    { label: "Avec témoins", value: avecTemoins, icon: Users, color: "var(--text1)", bg: "#EDEEF0" },
    { label: "Dégâts matériels", value: degatsMateriels, icon: Car, color: "var(--degatsMat)", bg: "#E4F0E8" },
  ];

  return (
    <div>
      {/* En-tête de page */}
      <div className="flex items-start justify-between mb-8">
        <div>
          <h2 className="text-3xl font-bold mb-1" style={{color: "var(--fond1)"}}>Tableau de bord</h2>
          <p style={{ color: "var(--text1)", paddingBottom: "5px"}}>Vue d'ensemble des constats enregistrés</p>
        </div>
        <button
          className="px-4 py-2 rounded-md text-sm font-medium"
          style={{ background: "white", color: "var(--fond1)", boxShadow: "var(--shadow)", padding: "10px"}}
        >
          Voir tous les constats →
        </button>
      </div>

      {/* Cartes statistiques */}
      <div className="grid grid-cols-4 gap-5 mb-8" style={{margin: "20px", padding: "12px"}}>
        {stats.map(({ label, value, icon: Icon, color, bg }) => (
          <div
            key={label}
            className="flex items-center gap-4 rounded-xl"
            style={{ background: "white", boxShadow: "var(--shadow)", padding: "20px" }}
          >
            <div
              className="w-12 h-12 rounded-lg flex items-center justify-center shrink-0"
              style={{ background: bg }}
            >
              <Icon size={22} color={color} />
            </div>
            <div>
              <div className="text-2xl font-bold" style={{ color: "var(--fond1)" }}>
                {value}
              </div>
              <div className="text-sm" style={{ color: "var(--text1)" }}>
                {label}
              </div>
            </div>
          </div>
        ))}
      </div>

      {/* Graphique */}
      <div className="rounded-xl p-6" style={{ background: "white", boxShadow: "var(--shadow)", padding: "12px"}}>
        <h4 className="text-lg font-bold" style={{marginBottom: "32px"}}>Constats par mois</h4>
        <ResponsiveContainer width="100%" height={320}>
          <BarChart data={parMois}>
            <CartesianGrid strokeDasharray="4 4" vertical={false} stroke="var(--social-bg)" />
            <XAxis
              dataKey="mois"
              tick={{ fill: "var(--text1)", fontSize: 14 }}
              axisLine={true}
              tickLine={false}
            />
            <YAxis
              allowDecimals={false}
              tick={{ fill: "var(--text1)", fontSize: 14 }}
              axisLine={false}
              tickLine={false}
            />
            <Bar dataKey="count" fill="var(--accent)" radius={[4, 4, 0, 0]} barSize={40} />
          </BarChart>
        </ResponsiveContainer>
      </div>
    </div>
  );
}