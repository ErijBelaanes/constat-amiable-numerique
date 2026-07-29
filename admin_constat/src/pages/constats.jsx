import { useState, useMemo } from "react";
import { Search } from "lucide-react";
import TableConstats from "../composents/TableConstats";
import ConfirmationSuppression from "../composents/confirmationSuppression";

export default function Constats({ constats, apiUrl, onRefresh }) {
  const [recherche, setRecherche] = useState("");
  const [filtre, setFiltre] = useState("tous");  //tous | blesses | temoins | degatsMateriels
  const [constatASupprimer, setConstatASupprimer] = useState(null);
  
  const constatsFiltres = useMemo(() => {
    return constats
      .filter((c) => {
        if (filtre === "tous") return true;
        return c[filtre] === true;
      })
      .filter((c) => {
        if (!recherche.trim()) return true;
        const q = recherche.toLowerCase();
        return (
          c.lieuAccident?.toLowerCase().includes(q) || 
          c.vehiculeA?.marque?.toLowerCase().includes(q) ||
          c.vehiculeB?.marque?.toLowerCase().includes(q) ||
          c.vehiculeA?.numImmatriculation?.toLowerCase().includes(q) ||
          c.vehiculeB?.numImmatriculation?.toLowerCase().includes(q)
        );
      });
  }, [constats, recherche, filtre]);

  //Ouvrir la confirmation de suppression
  function handleDelete(id){
    setConstatASupprimer(id);
  }

  async function confirmerSuppression() {
    try {
      const response = await fetch(`${apiUrl}/constats/${constatASupprimer}`,
        {
          method: "DELETE",
        }
      );
      if (!response.ok) {
        throw new Error("Erreur lors de la suppression");
      }
      setConstatASupprimer(null);
      onRefresh?.();  //Rafraîchir la liste après suppression
    } catch (error) {
      console.error(error);
    }
  }

  function handlePdf(id) {
    console.log("apiUrl utilisé:", apiUrl);
    window.open(`${apiUrl}/constats/${id}/pdf`, "_blank", "noopener,noreferrer");
  }

  const filtres = [  //Liste des boutons de filtre
    { key: "tous", label: "Tous" },
    { key: "blesses", label: "Avec blessés" },
    { key: "temoins", label: "Avec témoins" },
    { key: "degatsMateriels", label: "Dégâts matériels" },
  ];

  return (
    <div>
      <div className="mb-8" style={{paddingBottom: "20px"}}>
        <h2 className="text-3xl font-bold mb-1">Constats</h2>
        <p style={{ color: "var(--text1)"}}>
          {constatsFiltres.length} constat{constatsFiltres.length > 1 ? "s" : ""} affiché{constatsFiltres.length > 1 ? "s" : ""}
        </p>
      </div>

      {/* Barre de recherche + filtres */}
      <div className="flex items-center gap-4 mb-6" style={{paddingBottom: "20px"}}>
        <div
          className="flex items-center gap-2 rounded-lg px-4 py-2 flex-1 max-w-sm"
          style={{ background: "white", boxShadow: "var(--shadow)" }}
        >
          <Search size={18} color="var(--text1)" />
          <input
            type="text"
            placeholder="Rechercher un lieu..."
            value={recherche}
            onChange={(e) => setRecherche(e.target.value)}
            className="w-full outline-none text-sm bg-transparent"
            style={{ color: "var(--fond1)", padding: "7px" }}
          />
        </div>

        <div className="flex gap-2">
          {filtres.map(({ key, label }) => {
            const actif = filtre === key;
            return (
              <button
                key={key}
                onClick={() => setFiltre(key)}
                className="px-4 py-2 rounded-lg text-sm font-medium transition-colors"
                style={{
                  background: actif ? "var(--accent)" : "white",
                  color: actif ? "var(--text2)" : "var(--text1)",
                  boxShadow: actif ? "none" : "var(--shadow)",
                  padding: "7px"
                }}
              >
                {label}
              </button>
            );
          })}
        </div>
      </div>

      <TableConstats 
        constats={constatsFiltres}
        onDelete={handleDelete}
        onViewPdf={handlePdf} 
      />

      {constatASupprimer && (
        <ConfirmationSuppression
          onConfirm={confirmerSuppression}
          onCancel={() => setConstatASupprimer(null)}
        />
      )}
    </div>
  );
}