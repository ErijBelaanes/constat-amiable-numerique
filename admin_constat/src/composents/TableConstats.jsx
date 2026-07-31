import { Eye, Trash2} from "lucide-react";

function formatDate(dateStr) {
  if (!dateStr) return "—";
  return new Date(dateStr).toLocaleDateString("fr-FR", {
    day: "2-digit",
    month: "2-digit",
    year: "numeric",
  });
}

//Récupération de la ville uniquement
function formatLieu(lieu){
  if(!lieu) return "-";
  const parties = lieu.split(",");
  return parties[parties.length-1].trim();
}

//Affichage de véhicule
function Vehicule({vehicule}){
  if(!vehicule) return "-";
  return (
    <div>
      {vehicule.marque || "-"}
      {" - "}
      {vehicule.numImmatriculation || "-"}
    </div>
  );
}

export default function TableConstats({constats, onDelete, onViewPdf}) {
  if (constats.length === 0) {
    return (
      <div
        className="rounded-xl p-10 text-center"
        style={{ 
          background: "white", 
          boxShadow: "var(--shadow)", 
          color: "var(--text1)" 
        }}
      >
        Aucun constat trouuvé
      </div>
    );
  }

  return (
    <div 
      className="rounded-xl overflow-hidden"
      style={{ background: "white", boxShadow: "var(--shadow)" }}
    >
      <table className="w-full text-sm">
        <thead>
          <tr style={{ background: "var(--fond2)" }}>
            {/* <th className="text-left px-5 py-8" style={{ color: "var(--fond1)" }}>ID</th> */}
            <th className="text-left px-5 py-8" style={{ color: "var(--fond1)" }}>Date</th>
            <th className="text-left px-5 py-8" style={{ color: "var(--fond1)" }}>Lieu</th>
            <th className="text-left px-5 py-8" style={{ color: "var(--fond1)" }}>Véhicule A</th>
            <th className="text-left px-5 py-8" style={{ color: "var(--fond1)" }}>Véhicule B</th>
            <th className="text-center px-5 py-8" style={{ color: "var(--fond1)" }}>Blessés</th>
            <th className="text-center px-5 py-8" style={{ color: "var(--fond1)" }}>Actions</th>
          </tr>
        </thead>
        <tbody>
          {constats.map((c) => (
            <tr
              key={c._id}
              style={{ borderTop: "1px solid #EEE" }}
              className="border-t hover:bg-black/[0.02]"
            >
              {/* <td className="px-5 py-8" style={{ color: "var(--fond1)" }}>
                {c._id}
                {c._id.slice(-8)}
              </td> */}
              <td className="px-5 py-8" style={{ color: "var(--fond1)" }}>
                {formatDate(c.dateAccident)}
              </td>
              <td className="px-5 py-8" style={{ color: "var(--fond1)" }}>
                {formatLieu(c.lieuAccident)}
              </td>
              <td className="px-5 py-8" style={{ color: "var(--fond1)" }}>
                <Vehicule vehicule={c.vehiculeA}/>
              </td>
              <td className="px-5 py-8">
                <Vehicule vehicule={c.vehiculeB}/>
              </td>
              <td className="px-5 py-8 text-center">
                <span
                    className="px-3 py-1 rounded text-xs font-medium"
                    style={{
                      background: c.blesses ? "#FBE7E9" : "#E7F8EC",
                      color: c.blesses ? "var(--alerte)" : "#15803D",
                      padding: "3px"
                    }}
                >
                  {c.blesses ? "Oui" : "Non"}
                </span>
              </td>

              <td className="px-5 py-8">
                <div className="flex justify-center gap-3">
                  <button
                    onClick={() => onViewPdf(c._id)}
                    className="p-2 rounded-lg hover:bg-black/5"
                    title="Voir PDF"
                    style={{padding: "3px"}}
                  >
                    <Eye size={20}/>
                  </button>
                   
                  <button
                    onClick={() => onDelete(c._id)}
                    className="p-2 rounded-lg hover:bg-black/5"
                    title="Supprimer"
                    style={{padding: "3px"}}
                  >
                    <Trash2 size={20} color="var(--alerte)"/>
                  </button>
                </div>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
}