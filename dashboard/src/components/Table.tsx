import type { ReactNode } from 'react';
import EmptyState from './EmptyState';
import LoadingSpinner from './LoadingSpinner';

export interface TableColumn<T> {
  key: string;
  header: string;
  className?: string;
  render: (item: T) => ReactNode;
}

interface TableProps<T> {
  columns: TableColumn<T>[];
  data: T[];
  loading?: boolean;
  emptyTitle: string;
  emptyDescription: string;
  keyExtractor: (item: T) => string | number;
}

function Table<T>({
  columns,
  data,
  loading = false,
  emptyTitle,
  emptyDescription,
  keyExtractor,
}: TableProps<T>) {
  if (loading) {
    return <LoadingSpinner label="Loading table data..." />;
  }

  if (!data.length) {
    return <EmptyState title={emptyTitle} description={emptyDescription} />;
  }

  return (
    <div className="overflow-hidden rounded-[28px] border border-slate-200 bg-white shadow-soft">
      <div className="overflow-x-auto">
        <table className="min-w-full divide-y divide-slate-200">
          <thead className="bg-slate-50">
            <tr className="text-left text-sm font-semibold text-slate-600">
              {columns.map((column) => (
                <th key={column.key} className={`px-6 py-4 ${column.className || ''}`}>
                  {column.header}
                </th>
              ))}
            </tr>
          </thead>

          <tbody className="divide-y divide-slate-100 bg-white">
            {data.map((item) => (
              <tr key={keyExtractor(item)} className="align-top text-sm text-slate-600">
                {columns.map((column) => (
                  <td key={column.key} className={`px-6 py-4 ${column.className || ''}`}>
                    {column.render(item)}
                  </td>
                ))}
              </tr>
            ))}
          </tbody>
        </table>
      </div>
    </div>
  );
}

export default Table;
