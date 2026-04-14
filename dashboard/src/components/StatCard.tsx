interface StatCardProps {
  label: string;
  value: string | number;
  hint: string;
}

function StatCard({ label, value, hint }: StatCardProps) {
  return (
    <div className="rounded-[28px] border border-white/60 bg-white/90 p-6 shadow-soft">
      <p className="text-sm font-medium text-slate-500">{label}</p>
      <p className="mt-4 text-4xl font-semibold tracking-tight text-slate-950">{value}</p>
      <p className="mt-3 text-sm text-slate-500">{hint}</p>
    </div>
  );
}

export default StatCard;
