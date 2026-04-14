interface LoadingSpinnerProps {
  label?: string;
}

function LoadingSpinner({ label = 'Loading data...' }: LoadingSpinnerProps) {
  return (
    <div className="flex min-h-[240px] flex-col items-center justify-center gap-4 rounded-3xl border border-dashed border-slate-300 bg-white/70 p-8 text-center shadow-soft">
      <div className="h-12 w-12 animate-spin rounded-full border-4 border-slate-200 border-t-teal-500" />
      <p className="text-sm font-medium text-slate-500">{label}</p>
    </div>
  );
}

export default LoadingSpinner;
