import { AlertTriangle, Trash2 } from "lucide-react";
export default function ConfirmationSuppression({
  onConfirm,
  onCancel
}) {
  return (
    <div
      className="fixed inset-0 flex items-center justify-center z-50"
      role="dialog"
      style={{
        background:"rgba(0,0,0,0.35)"
      }}
    >
      <div
        className="rounded-2xl p-6 w-[520px]"
        style={{
          background:"white",
          boxShadow:"0 10px 30px rgba(0,0,0,0.15)",
          padding: "20px"
        }}
      >
         {/* Titre */}
         <div className="flex items-center gap-3 mb-6">
           <AlertTriangle
             size={24}
             color="#C23B4A"
           />
           <h2
             className="text-lg font-bold"
             style={{
               color:"#C23B4A"
             }}
           >
             Supprimer ce constat ?
           </h2>
         </div>
         {/* Message */}
         <p
           className="text-sm leading-7 mb-8"
           style={{
             color:"var(--text1)"
           }}
         >
           Cette action est définitive. Le constat et toutes ses
           données (véhicules, croquis, signatures) seront supprimés.
         </p>
         {/* Boutons */}
         <div className="flex justify-end gap-5" style={{marginTop: "36px"}}>
              <button
                onClick={onCancel}
                className="flex items-center gap-2 rounded-lg"
                style={{
                  background:"var(--fond2)",
                  color:"var(--texte1)",
                  padding: "7px",
                  width: "fit-content"
                }}
              >
                Annuler
              </button>
              <button
                onClick={onConfirm}
                className="flex items-center gap-2 rounded-lg"
                style={{
                  background:"#C23B4A",
                  color:"white",
                  padding: "7px",
                  width: "fit-content"
                }}
              >
                <Trash2 size={17} color="white"/>
                Supprimer
              </button>
         </div>
      </div>

    </div>
  );
}